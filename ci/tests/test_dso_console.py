"""Render-only regression tests. Requires Helm 3 and PyYAML; no cluster needed."""

import base64
from pathlib import Path
import subprocess
import tempfile
import unittest

import yaml


CHART = Path(__file__).resolve().parents[2] / "charts" / "dso-console"
FULLNAME = "console-cpn-console"


def render(values=None, upgrade=False):
    options = {
        "postgresql": {"enabled": False},
        "keycloak": {"enabled": False},
        "cnpg-operator": {"enabled": False},
    }
    options.update(values or {})
    with tempfile.NamedTemporaryFile(mode="w", suffix=".yaml") as values_file:
        yaml.safe_dump(options, values_file)
        values_file.flush()
        command = ["helm", "template", "console", str(CHART), "-f", values_file.name]
        if upgrade:
            command.append("--is-upgrade")
        result = subprocess.run(command, check=True, capture_output=True, text=True)
    return [doc for doc in yaml.safe_load_all(result.stdout) if doc]


def resource(documents, kind, suffix=""):
    return next(
        doc for doc in documents
        if doc["kind"] == kind and doc["metadata"]["name"] == FULLNAME + suffix
    )


class ConsoleRenderingTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.documents = render()

    def test_only_client_and_nestjs_deployments(self):
        deployments = [doc for doc in self.documents if doc["kind"] == "Deployment"]
        self.assertEqual(
            {doc["metadata"]["name"] for doc in deployments},
            {FULLNAME + "-client", FULLNAME + "-backend"},
        )

    def test_no_legacy_resources_or_images(self):
        for doc in self.documents:
            with self.subTest(kind=doc["kind"], name=doc["metadata"]["name"]):
                self.assertNotIn("strangler", yaml.safe_dump(doc))
                self.assertFalse(doc["metadata"]["name"].endswith("-server"))
                if doc["kind"] == "Deployment":
                    for container in doc["spec"]["template"]["spec"]["containers"]:
                        self.assertNotRegex(container["image"], r"/server:")
        defaults = yaml.safe_load((CHART / "values.yaml").read_text())
        self.assertNotIn("server", defaults)
        self.assertNotIn("strangler", defaults)

    def test_ingress_routes_api_and_maintained_swagger_to_backend(self):
        paths = resource(self.documents, "Ingress")["spec"]["rules"][0]["http"]["paths"]
        self.assertEqual(
            {p["path"]: p["backend"]["service"] for p in paths},
            {
                "/": {"name": FULLNAME + "-client", "port": {"number": 80}},
                "/api": {"name": FULLNAME + "-backend", "port": {"number": 80}},
                "/swagger-ui-server-nestjs": {
                    "name": FULLNAME + "-backend", "port": {"number": 80},
                },
                "/swagger-ui-server-nestjs-json": {
                    "name": FULLNAME + "-backend", "port": {"number": 80},
                },
                "/swagger-ui-server-nestjs-yaml": {
                    "name": FULLNAME + "-backend", "port": {"number": 80},
                },
            },
        )
        for path in paths:
            expected_type = "Exact" if path["path"].endswith(("-json", "-yaml")) else "Prefix"
            self.assertEqual(path["pathType"], expected_type)

    def test_client_uses_backend_service_and_custom_port(self):
        docs = render({"backend": {"service": {"port": 8081}}})
        config = resource(docs, "ConfigMap", "-client")["data"]
        self.assertEqual(config["SERVER_HOST"], FULLNAME + "-backend")
        self.assertEqual(config["SERVER_PORT"], "8081")
        paths = resource(docs, "Ingress")["spec"]["rules"][0]["http"]["paths"]
        for path in paths[1:]:
            self.assertEqual(path["backend"]["service"]["port"]["number"], 8081)

    def test_backend_ports_probes_and_image_entrypoint_are_preserved(self):
        docs = render({"backend": {"container": {"port": 3002}}})
        deployment = resource(docs, "Deployment", "-backend")
        container = deployment["spec"]["template"]["spec"]["containers"][0]
        self.assertTrue(container["image"].startswith("ghcr.io/cloud-pi-native/console/server-nestjs:"))
        self.assertNotIn("command", container)
        self.assertNotIn("args", container)
        for probe in ("startupProbe", "readinessProbe", "livenessProbe"):
            self.assertEqual(container[probe]["httpGet"], {"path": "/api/v1/healthz", "port": 3002})
        service = resource(docs, "Service", "-backend")
        self.assertEqual(service["spec"]["ports"][0]["targetPort"], 3002)
        self.assertEqual(service["spec"]["selector"], deployment["spec"]["selector"]["matchLabels"])

    def test_ingress_can_be_disabled(self):
        self.assertFalse(any(d["kind"] == "Ingress" for d in render({"ingress": {"enabled": False}})))

    def test_ingress_preserves_controller_annotations_hosts_and_tls(self):
        annotations = {
            "nginx.ingress.kubernetes.io/proxy-read-timeout": "3600",
            "nginx.ingress.kubernetes.io/proxy-buffering": "off",
        }
        tls = [{"secretName": "console-tls", "hosts": ["console.example.test"]}]
        docs = render({"ingress": {
            "className": "custom", "annotations": annotations,
            "hosts": ["console.example.test", "other.example.test"], "tls": tls,
        }})
        ingress = resource(docs, "Ingress")
        self.assertEqual(ingress["metadata"]["annotations"], annotations)
        self.assertEqual(ingress["spec"]["tls"], tls)
        self.assertEqual(ingress["spec"]["ingressClassName"], "custom")
        self.assertEqual(len(ingress["spec"]["rules"]), 2)
        for rule in ingress["spec"]["rules"]:
            self.assertEqual(rule["http"]["paths"][1]["backend"]["service"]["name"], FULLNAME + "-backend")

    def test_autoscaling_targets_only_remaining_deployments(self):
        docs = render({"backend": {"autoscaling": {"enabled": True}}})
        hpa = resource(docs, "HorizontalPodAutoscaler", "-backend")
        self.assertEqual(hpa["spec"]["scaleTargetRef"]["name"], FULLNAME + "-backend")
        self.assertNotIn("replicas", resource(docs, "Deployment", "-backend")["spec"])

    def test_external_database_and_keycloak_secrets_are_preserved(self):
        db_url = "postgresql://console:password@existing-db/console?schema=public"
        docs = render({"global": {
            "postgresql": {"dbUrl": db_url},
            "keycloak": {"clientSecrets": {"backend": "test-client-secret"}},
        }})
        secret = resource(docs, "Secret", "-backend")["data"]
        self.assertEqual(base64.b64decode(secret["DB_URL"]).decode(), db_url)
        self.assertEqual(base64.b64decode(secret["KEYCLOAK_CLIENT_SECRET"]).decode(), "test-client-secret")

    def test_cnpg_credentials_remain_sourced_from_existing_secret(self):
        docs = render({"global": {"postgresql": {"cnpgSecretName": "existing-cnpg-app"}}})
        self.assertNotIn("DB_URL", resource(docs, "Secret", "-backend")["data"])
        container = resource(docs, "Deployment", "-backend")["spec"]["template"]["spec"]["containers"][0]
        db_env = next(env for env in container["env"] if env["name"] == "DB_URL")
        self.assertEqual(db_env["valueFrom"]["secretKeyRef"], {"name": "existing-cnpg-app", "key": "uri"})

    def test_old_values_do_not_recreate_legacy_resources_on_upgrade(self):
        docs = render({
            "server": {"image": {"repository": "unused-legacy-server"}, "autoscaling": {"enabled": True}},
            "strangler": {"image": {"repository": "unused-strangler"}, "autoscaling": {"enabled": True}},
        }, upgrade=True)
        for doc in docs:
            self.assertNotIn("strangler", yaml.safe_dump(doc))
            self.assertFalse(doc["metadata"]["name"].endswith("-server"))
        self.assertEqual(
            resource(docs, "Service", "-backend")["spec"],
            resource(self.documents, "Service", "-backend")["spec"],
        )

    def test_target_image_tags_can_be_set_without_renaming_repositories(self):
        docs = render({"backend": {"image": {"tag": "v9.29.0"}}, "client": {"image": {"tag": "v9.29.0"}}})
        for suffix, image in (("-backend", "server-nestjs"), ("-client", "client")):
            container = resource(docs, "Deployment", suffix)["spec"]["template"]["spec"]["containers"][0]
            self.assertEqual(container["image"], f"ghcr.io/cloud-pi-native/console/{image}:v9.29.0")


if __name__ == "__main__":
    unittest.main()
