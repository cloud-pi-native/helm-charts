# cpn-opencds-mockoon

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 9.18.0](https://img.shields.io/badge/AppVersion-9.18.0-informational?style=flat-square)

A Helm chart to deploy a mocked API (through Mockoon) of OpenCDS

**Homepage:** <https://cloud-pi-native.fr>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| StephaneTrebel | <cloudpinative-relations@interieur.gouv.fr> | <https://www.interieur.gouv.fr/> |

## Source Code

* <https://github.com/cloud-pi-native/helm-charts>
* <https://github.com/cloud-pi-native/console>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| config.create | bool | `false` | Whether or not helm should create the console config. |
| config.name | string | `"dso-config"` | Name of the generated config. |
| config.projectsRootDir | string | `"forge"` | Projects root directory to use in other services such as Gitlab, etc. |
| config.secrets | object | `{}` | Secrets to inject into the configuration. It is needed for the backend to get services informations such as urls, admin username, admin password or token, etc. |
| fullnameOverride | string | `""` | String to fully override the default application name. |
| global.secrets | object | `{}` | Map of environment variables to inject into backend and frontend containers. |
| imageCredentials.email | string | `""` | Email to pull images. |
| imageCredentials.password | string | `""` | Password to pull images. |
| imageCredentials.registry | string | `""` | Registry to pull images from. |
| imageCredentials.username | string | `""` | Username to pull images. |
| nameOverride | string | `""` | Provide a name in place of the default application name. |
| opencds.affinity | object | `{}` | Default affinity for Console CPN opencds. |
| opencds.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the Console CPN opencds. |
| opencds.autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the Console CPN opencds [HPA]. |
| opencds.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the Console CPN opencds [HPA]. |
| opencds.autoscaling.targetCPUUtilizationPercentage | int | `80` | Average CPU utilization percentage for the Console CPN opencds [HPA]. |
| opencds.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average memory utilization percentage for the Console CPN opencds [HPA]. |
| opencds.container.args | list | `[]` | Console CPN opencds container command args. |
| opencds.container.command | list | `[]` | Console CPN opencds container command. |
| opencds.container.port | int | `3100` | Console CPN opencds container port. |
| opencds.container.securityContext | object | `{}` | Toggle and define container-level security context. |
| opencds.enabled | bool | `false` | Enable OpenCDS service Defaulted to false because we want to enable it only on some environments and we do NOT want to enable it on prod-like environments |
| opencds.env | object | `{}` | Console CPN opencds container env variables, it will be injected into a configmap and loaded into the container. |
| opencds.envFrom | list | `[]` | Console CPN opencds container env variables loaded from configmap or secret reference. |
| opencds.extraContainers | list | `[]` | Extra containers to add to the Console CPN opencds pod as sidecars. |
| opencds.extraVolumeMounts | list | `[]` | List of extra mounts to add (normally used with extraVolumes). |
| opencds.extraVolumes | list | `[]` | List of extra volumes to add. |
| opencds.healthcheckPath | string | `"/health"` | Console CPN opencds container healthcheck endpoint. |
| opencds.hostAliases | list | `[]` | Host aliases that will be injected at pod-level into /etc/hosts. |
| opencds.image.pullPolicy | string | `"Always"` | Image pull policy for the Console CPN opencds. |
| opencds.image.repository | string | `"ghcr.io/cloud-pi-native/console/opencds-mockoon"` | Repository to use for the Console CPN opencds. |
| opencds.image.tag | string | `""` | Tag to use for the Console CPN opencds. # Overrides the image tag whose default is the chart appVersion. |
| opencds.initContainers | list | `[]` | Init containers to add to the Console CPN opencds pod. |
| opencds.livenessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| opencds.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| opencds.livenessProbe.initialDelaySeconds | int | `30` | Number of seconds after the container has started before probe is initiated. |
| opencds.livenessProbe.periodSeconds | int | `30` | How often (in seconds) to perform the probe. |
| opencds.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| opencds.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out |
| opencds.nodeSelector | object | `{}` | Default node selector for Console CPN opencds. |
| opencds.podAnnotations | object | `{}` | Annotations for the Console CPN opencds deployed pods. |
| opencds.podLabels | object | `{}` | Labels for the Console CPN opencds deployed pods. |
| opencds.podSecurityContext | object | `{}` | Toggle and define pod-level security context. |
| opencds.readinessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| opencds.readinessProbe.failureThreshold | int | `2` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| opencds.readinessProbe.initialDelaySeconds | int | `15` | Number of seconds after the container has started before probe is initiated. |
| opencds.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| opencds.readinessProbe.successThreshold | int | `2` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| opencds.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| opencds.replicaCount | int | `1` | The number of application controller pods to run. |
| opencds.resources.limits.cpu | string | `"500m"` | CPU limit for the Console CPN opencds. |
| opencds.resources.limits.memory | string | `"512Mi"` | Memory limit for the Console CPN opencds. |
| opencds.resources.requests.cpu | string | `"250m"` | CPU request for the Console CPN opencds. |
| opencds.resources.requests.memory | string | `"128Mi"` | Memory request for the Console CPN opencds. |
| opencds.secrets | object | `{}` | Console CPN opencds container env secrets, it will be injected into a secret and loaded into the container. |
| opencds.service.port | int | `80` | Console CPN opencds service port. |
| opencds.service.type | string | `"ClusterIP"` | Console CPN opencds service type. |
| opencds.startupProbe.enabled | bool | `true` | Whether or not enable the probe. |
| opencds.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| opencds.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before probe is initiated. |
| opencds.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| opencds.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| opencds.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| opencds.strategy.type | string | `"RollingUpdate"` | Strategy type used to replace old Pods by new ones, can be "Recreate" or "RollingUpdate". |
| opencds.tolerations | list | `[]` | Default tolerations for Console CPN opencds. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
