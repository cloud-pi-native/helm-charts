# Upgrading dso-console from 2.x to 3.x

## Version pairing

Chart 3.x removes the legacy Fastify server and nginx-strangler. It targets
Console **v9.29.0**, whose release follows the preparatory chart MR. The image
repositories remain `ghcr.io/cloud-pi-native/console/client` and
`ghcr.io/cloud-pi-native/console/server-nestjs`; do not rename the latter to
`console/server`.

During preparation, `Chart.yaml` retains `appVersion: v9.28.0` for the separate
application-version update. **Do not deploy this chart using those default image
tags.** Once v9.29.0 is published, use the chart associated with it, or explicitly
set both image tags:

```yaml
client:
  image:
    tag: v9.29.0
backend:
  image:
    tag: v9.29.0
```

No image publication, runtime qualification or data migration is proved by a
successful Helm render. This change only covers this charts repository; changes
to installation/instance repositories are outside this MR's scope.

## Values and resource migration

- `server.*` and `strangler.*` are removed. Old values supplied to Helm are ignored,
  not automatically migrated to `backend.*`. Review values before upgrading;
  avoid blindly using `--reuse-values`.
- Transfer required legacy `server.env`, `secrets`, `envFrom`, resources, affinity,
  tolerations, CA certificates, volumes and init/sidecar configuration to their
  `backend.*` counterparts. Reconcile with existing backend values rather than
  overwriting them. Check application-level compatibility of external plugins
  before copying `server.plugins` or `server.disabledPlugins`.
- Do not copy legacy image repositories, container ports, health paths or
  container commands. The NestJS container listens on 3001 by default, and all
  backend probes use `/api/v1/healthz`. Its Service defaults to port 80.
- The existing backend Deployment, selectors, Service and ServiceAccount keep
  their identities. If external RBAC grants were attached to the legacy
  `cpn-console-server` ServiceAccount, transfer the necessary grants to
  `backend.serviceAccount.name` (default `cpn-console-backend`) before upgrading.
- Helm removes legacy server/strangler Deployments, Services, ConfigMaps, Secrets,
  HPAs (when enabled), and the legacy server's ServiceAccount, ClusterRole and
  ClusterRoleBinding. Transfer any required values from the old resources first.
- Keep the same release name/namespace, PostgreSQL/CNPG configuration, credentials,
  database name, PVCs and external database secrets. This change does not modify
  the PostgreSQL/Keycloak dependencies or CNPG templates. Never uninstall the
  release or delete storage to perform this upgrade.

## Ingress and reverse-proxy contract

| Path | Destination |
| --- | --- |
| `/` | Existing client Service (static Nginx) |
| `/api` | Existing backend Service (NestJS) |
| `/swagger-ui-server-nestjs` (Prefix) | Existing backend Service (NestJS) |
| `/swagger-ui-server-nestjs-json` (Exact) | Existing backend Service (NestJS) |
| `/swagger-ui-server-nestjs-yaml` (Exact) | Existing backend Service (NestJS) |

The raw JSON/YAML documents are separate NestJS routes, not children of the UI
path. They need explicit rules: Kubernetes Prefix matching is path-segment based
and must not be assumed to match the `-json` and `-yaml` suffixes.

The legacy `/swagger-ui-server` route is removed; it is not an alias for the
maintained Swagger. Update bookmarks and monitoring accordingly. No API or
Swagger path rewrite is needed. If `ingress.enabled=false`, update the external
router to target the backend instead of the removed strangler Service.

Ingress annotations, class, hosts and TLS remain configurable. Removing the
intermediate proxy means the Ingress controller must provide the required proxy
behavior. Check its configuration, including trusted upstream load balancers:

- Preserve `Host`, `X-Forwarded-Proto`, `X-Forwarded-For` and client-address headers;
  validate HTTPS URLs and authentication through the actual external endpoint.
  Do not trust client-supplied forwarded headers indiscriminately.
- Use HTTP/1.1 and forward WebSocket `Upgrade`/`Connection` correctly for endpoints
  that need them. Verify an actual authenticated WebSocket connection where used.
- Size request-header buffers for Keycloak tokens. The removed proxy used
  `large_client_header_buffers 4 32k`; this is different from response buffers.
  Check both the controller's request-header limits and response-header buffers.
- Disable response buffering for streamed API responses where required, avoid
  unwanted redirect rewriting and set read/send timeouts long enough for actual
  streams/WebSocket connections. The removed proxy disabled buffering and
  redirect rewriting on its `/api/` fallback and otherwise used Nginx defaults.

For ingress-nginx, the following is an **example to adapt**, not a portable
configuration or proof of working authentication/WebSocket behavior:

```yaml
ingress:
  annotations:
    nginx.ingress.kubernetes.io/proxy-http-version: "1.1"
    nginx.ingress.kubernetes.io/proxy-buffering: "off"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "3600"
    nginx.ingress.kubernetes.io/proxy-buffer-size: "32k"
```

Configure request-header limits (for example `large-client-header-buffers`) and
forwarded-header trust in the controller configuration, not by assuming these
annotations cover them. Other controllers require their own equivalent settings.
The client Nginx remains useful for static files; it is not an API reverse proxy.

## Prisma and data-preservation checklist

1. Before upgrading, take and verify a restorable database backup. Record the
   existing release/chart/image versions, database identity, PVCs and baseline
   project/user/environment records without exposing credentials.
2. Prepare reviewed values as described above. Render with `helm template` and
   compare against `helm get manifest` (store manifests securely: they contain
   Secrets). Confirm only legacy resources disappear, backend selectors remain
   stable and database/volume references remain unchanged.
3. Preserve the NestJS production image's default entrypoint, which runs
   `npm run db:deploy` before starting the application. Leave
   `backend.container.command` and `args` empty unless an audited override preserves
   this behavior. Do not add a second competing migration runner.
4. On a dedicated qualification environment, test both a fresh installation and
   an upgrade of a database with representative existing records. Allow enough
   startup-probe time for migrations; adapt `backend.startupProbe` to measured
   migration duration if necessary. Inspect backend startup logs and the Prisma
   migration history for successful completion before accepting traffic.
5. Verify readiness, `/api/v1/healthz`, login/token refresh, authenticated API calls,
   authorization failures, large Keycloak headers, Swagger UI and its JSON,
   streaming/WebSocket endpoints where used, and record counts/representative
   existing data. Confirm no traffic or workload still depends on legacy services.
6. Retain evidence and the exact chart version, client/backend image tags or
   digests, controller version/settings and tested database upgrade path. A Helm
   rollback does not reverse Prisma migrations; use an application-compatible
   recovery procedure and the verified backup rather than assuming automatic
   database rollback.

## Automated checks and remaining qualification

Run from the repository root with Helm 3 and PyYAML 6.0.3:

```sh
python3 -m unittest discover -s ci/tests -v
helm lint charts/dso-console
```

These checks cover resource removal, API/Swagger routes, configurable ports,
Ingress options, backend probes/default command, credentials and rendering with
old values in upgrade mode. They do **not** install a release or execute Prisma.
Real fresh-install/upgrade, authentication, WebSocket and data-preservation
qualification remains required after the v9.29.0 images are available. Track those
proofs and the delivered version pairing in issue
[313](https://github.com/cloud-pi-native/helm-charts/issues/313).
