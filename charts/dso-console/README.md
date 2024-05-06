# cpn-console

![Version: 1.1.2](https://img.shields.io/badge/Version-1.1.2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 8.2.1](https://img.shields.io/badge/AppVersion-8.2.1-informational?style=flat-square)

A Helm chart to deploy Cloud Pi Native Console

**Homepage:** <https://cloud-pi-native.fr>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Thibault Colin | <thibault.colin@interieur.gouv.fr> | <https://this-is-tobi.com> |

## Source Code

* <https://github.com/cloud-pi-native/console>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | keycloak | 19.3.0 |
| https://charts.bitnami.com/bitnami | postgresql | 12.7.3 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| client.affinity | object | `{}` | Default affinity for Console CPN client. |
| client.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the Console CPN client. |
| client.autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the Console CPN client [HPA]. |
| client.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the Console CPN client [HPA]. |
| client.autoscaling.targetCPUUtilizationPercentage | int | `80` | Average CPU utilization percentage for the Console CPN client [HPA]. |
| client.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average memory utilization percentage for the Console CPN client [HPA]. |
| client.container.args | list | `[]` | Console CPN client container command args. |
| client.container.command | list | `[]` | Console CPN client container command. |
| client.container.port | int | `8080` | Console CPN client container port. |
| client.container.securityContext | object | `{}` | Toggle and define container-level security context. |
| client.env | object | `{}` | Console CPN client container env variables, it will be injected into a configmap and loaded into the container. |
| client.extraContainers | string | `nil` | Extra containers to add to the Console CPN client pod as sidecars. |
| client.extraVolumeMounts | list | `[]` | List of extra mounts to add (normally used with extraVolumes). |
| client.extraVolumes | list | `[]` | List of extra volumes to add. |
| client.healthcheckPath | string | `"/"` | Console CPN client container healthcheck endpoint. |
| client.hostAliases | list | `[]` | Host aliases that will be injected at pod-level into /etc/hosts. |
| client.image.pullPolicy | string | `"Always"` | Image pull policy for the Console CPN client. |
| client.image.repository | string | `"ghcr.io/cloud-pi-native/console/client"` | Repository to use for the Console CPN client. |
| client.image.tag | string | `""` | Tag to use for the Console CPN client. # Overrides the image tag whose default is the chart appVersion. |
| client.initContainers | list | `[]` | Init containers to add to the Console CPN client pod. |
| client.livenessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| client.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| client.livenessProbe.initialDelaySeconds | int | `30` | Number of seconds after the container has started before probe is initiated. |
| client.livenessProbe.periodSeconds | int | `30` | How often (in seconds) to perform the probe. |
| client.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| client.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out |
| client.nodeSelector | object | `{}` | Default node selector for Console CPN client. |
| client.podAnnotations | object | `{}` | Annotations for the Console CPN client deployed pods. |
| client.podLabels | object | `{}` | Labels for the Console CPN client deployed pods. |
| client.podSecurityContext | object | `{}` | Toggle and define pod-level security context. |
| client.readinessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| client.readinessProbe.failureThreshold | int | `2` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| client.readinessProbe.initialDelaySeconds | int | `15` | Number of seconds after the container has started before probe is initiated. |
| client.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| client.readinessProbe.successThreshold | int | `2` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| client.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| client.replicaCount | int | `1` | The number of application controller pods to run. |
| client.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"128Mi"}}` | Resource limits and requests for the Console CPN client. |
| client.secrets | object | `{}` | Console CPN client container env secrets, it will be injected into a secret and loaded into the container. |
| client.service.port | int | `80` | Console CPN client service port. |
| client.service.type | string | `"ClusterIP"` | Console CPN client service type. |
| client.startupProbe.enabled | bool | `true` | Whether or not enable the probe. |
| client.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| client.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before probe is initiated. |
| client.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| client.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| client.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| client.strategy.type | string | `"RollingUpdate"` | Strategy type used to replace old Pods by new ones, can be "Recreate" or "RollingUpdate". |
| client.tolerations | list | `[]` | Default tolerations for Console CPN client. |
| config.create | bool | `false` | Whether or not helm should create the console config. |
| config.name | string | `"dso-config"` | Name of the genrated config. |
| config.projectsRootDir | string | `"forge"` | Projects root directory to use in other services such as Gitlab, etc. |
| config.secrets | string | `nil` | Secrets to inject into the configuration. It is needed for server to get services informations such as urls, admin username, admin password or token, etc. |
| fullnameOverride | string | `""` | String to fully override the default application name. |
| global.env | object | `{"NODE_ENV":"production"}` | Map of environment variables to inject into backend and frontend containers. |
| global.keycloak.clientIds.backend | string | `"console-backend"` | Keycloak clientId used for Console CPN client. |
| global.keycloak.clientIds.frontend | string | `"console-frontend"` | Keycloak clientId used for frontend. |
| global.keycloak.clientSecrets.backend | string | `""` | Keycloak clientSecret used for Console CPN client. |
| global.keycloak.domain | string | `"keycloak.domain.com"` | Keycloak domain used for authentication. |
| global.keycloak.protocol | string | `"https"` | Protocol used to communicate with keycloak for authentication. |
| global.keycloak.realm | string | `"cloud-pi-native"` | Name of the keycloak realm used for authentication. |
| global.keycloak.redirectUri | string | `"https://console.dso.local"` | Keycloak redirect uri used with keycloak. |
| global.keycloak.sessionSecret | string | `"a-very-strong-secret-with-more-than-32-char"` | Session secret used to store keycloak session for Console CPN client. |
| global.postgresql.dbUrl | string | `""` | Postgres database connection string used to override computed db url, usefull if external database. # For postgres it should look like this "postgresql://db_user:db_password@db_service:db_port/db_name?schema=public" |
| global.secrets | object | `{}` | Map of environment variables to inject into backend and frontend containers. |
| imageCredentials.email | string | `""` | Email to pull images. |
| imageCredentials.password | string | `""` | Password to pull images. |
| imageCredentials.registry | string | `""` | Registry to pull images from. |
| imageCredentials.username | string | `""` | Username to pull images. |
| ingress.annotations | object | `{}` | Additional ingress annotations. |
| ingress.className | string | `""` | Defines which ingress controller will implement the resource. |
| ingress.enabled | bool | `true` | Whether or not ingress should be enabled. |
| ingress.hosts | list | `["console.dso.local"]` | The list of hosts to be covered by ingress record. |
| ingress.labels | object | `{}` | Additional ingress labels. |
| ingress.tls | list | `[]` | Enable TLS configuration. |
| keycloak.auth.adminPassword | string | `""` |  |
| keycloak.auth.adminUser | string | `""` |  |
| keycloak.enabled | bool | `false` |  |
| keycloak.ingress.annotations | object | `{}` |  |
| keycloak.ingress.enabled | bool | `true` |  |
| keycloak.ingress.hostname | string | `"keycloak.dso.local"` |  |
| keycloak.ingress.ingressClassName | string | `""` |  |
| keycloak.ingress.path | string | `"/"` |  |
| keycloak.ingress.secrets | list | `[]` |  |
| keycloak.ingress.tls | bool | `false` |  |
| keycloak.nameOverride | string | `"cpn-keycloak"` |  |
| keycloak.postgresql.auth.architecture | string | `"standalone"` |  |
| keycloak.postgresql.auth.database | string | `"keycloak"` |  |
| keycloak.postgresql.auth.password | string | `""` |  |
| keycloak.postgresql.auth.postgresPassword | string | `""` |  |
| keycloak.postgresql.auth.username | string | `""` |  |
| keycloak.postgresql.enabled | bool | `true` |  |
| keycloak.postgresql.nameOverride | string | `"cpn-keycloak-db"` |  |
| keycloak.production | bool | `true` |  |
| keycloak.proxy | string | `"edge"` |  |
| keycloak.tls.autoGenerated | bool | `false` |  |
| keycloak.tls.enabled | bool | `false` |  |
| nameOverride | string | `""` | Provide a name in place of the default application name. |
| postgresql.architecture | string | `"standalone"` |  |
| postgresql.auth.database | string | `""` |  |
| postgresql.auth.password | string | `""` |  |
| postgresql.auth.postgresPassword | string | `""` |  |
| postgresql.auth.username | string | `""` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.nameOverride | string | `"cpn-console-db"` |  |
| postgresql.primary.persistence.size | string | `"2Gi"` |  |
| postgresql.primary.resources.limits.cpu | string | `"500m"` |  |
| postgresql.primary.resources.limits.memory | string | `"512Mi"` |  |
| postgresql.primary.resources.requests.cpu | string | `"250m"` |  |
| postgresql.primary.resources.requests.memory | string | `"128Mi"` |  |
| postgresql.primary.service.ports.postgresql | int | `5432` |  |
| postgresql.primary.service.type | string | `"ClusterIP"` |  |
| postgresql.readReplicas.persistence.size | string | `"2Gi"` |  |
| server.affinity | object | `{}` | Default affinity for Console CPN server. |
| server.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the Console CPN server. |
| server.autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the Console CPN server [HPA]. |
| server.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the Console CPN server [HPA]. |
| server.autoscaling.targetCPUUtilizationPercentage | int | `80` | Average CPU utilization percentage for the Console CPN server [HPA]. |
| server.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average memory utilization percentage for the Console CPN server [HPA]. |
| server.container.args | list | `[]` | Console CPN server container command args. |
| server.container.command | list | `[]` | Console CPN server container command. |
| server.container.port | int | `8080` | Console CPN server container port. |
| server.container.securityContext | object | `{}` | Toggle and define container-level security context. |
| server.dbDataCm | string | `""` | Name of the configmap with javascript data that need to be imported by the server at start up. |
| server.disabledPlugins | string | `""` | CSV list of plugins to disabled. |
| server.env | object | `{}` | Console CPN server container env variables, it will be injected into a configmap and loaded into the container. |
| server.extraCa | object | `{"key":"","mountSubPath":"ca_certs","name":""}` | Extra certificate to add to the container, it should be provide as a configmap. |
| server.extraCa.key | string | `""` | The key to lookup. |
| server.extraCa.mountSubPath | string | `"ca_certs"` | The path inside the container where the certificate file should be mount. This is a native Nodejs environment variable to extends certificates, see: https://nodejs.org/api/cli.html#node_extra_ca_certsfile. This mount path represent the subpath to use under the `/config` config root path. |
| server.extraCa.name | string | `""` | The name of the configmap in namespace where certificates are stored. |
| server.extraContainers | string | `nil` | Extra containers to add to the Console CPN server pod as sidecars. |
| server.extraVolumeMounts | list | `[]` | List of extra mounts to add (normally used with extraVolumes) |
| server.extraVolumes | list | `[]` | List of extra volumes to add. |
| server.healthcheckPath | string | `"/api/v1/healthz"` | Console CPN server container healthcheck endpoint. |
| server.hostAliases | list | `[]` | Host aliases that will be injected at pod-level into /etc/hosts. |
| server.image.pullPolicy | string | `"Always"` | Image pull policy for the Console CPN server. |
| server.image.repository | string | `"ghcr.io/cloud-pi-native/console/server"` | Repository to use for the Console CPN server. |
| server.image.tag | string | `""` | Tag to use for the Console CPN server. # Overrides the image tag whose default is the chart appVersion. |
| server.initContainers | list | `[]` | Init containers to add to the Console CPN client pod. |
| server.livenessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| server.livenessProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| server.livenessProbe.initialDelaySeconds | int | `30` | Whether or not enable the probe. |
| server.livenessProbe.periodSeconds | int | `30` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| server.livenessProbe.successThreshold | int | `1` | Number of seconds after the container has started before probe is initiated. |
| server.livenessProbe.timeoutSeconds | int | `5` | How often (in seconds) to perform the probe. |
| server.nodeSelector | object | `{}` | Default node selector for Console CPN server. |
| server.plugins | list | `[]` | List of zips to download; basically curl url, unzip and stores it in plugins/external/<dir_name>. |
| server.podAnnotations | object | `{}` | Annotations for the Console CPN server deployed pods. |
| server.podLabels | object | `{}` | Labels for the Console CPN server deployed pods. |
| server.podSecurityContext | object | `{}` | Toggle and define pod-level security context. |
| server.readinessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| server.readinessProbe.failureThreshold | int | `2` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| server.readinessProbe.initialDelaySeconds | int | `15` | Number of seconds after the container has started before probe is initiated. |
| server.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| server.readinessProbe.successThreshold | int | `2` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| server.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| server.replicaCount | int | `1` | The number of application controller pods to run. |
| server.resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"128Mi"}}` | Resource limits and requests for the Console CPN server. |
| server.secrets | object | `{}` | Console CPN server container env secrets, it will be injected into a secret and loaded into the container. |
| server.service.port | int | `80` | Console CPN server service port. |
| server.service.type | string | `"ClusterIP"` | Console CPN server service type. |
| server.serviceAccount.annotations | object | `{}` | Annotations applied to created service account. |
| server.serviceAccount.create | bool | `true` | Create a service account for the Console CPN server. |
| server.serviceAccount.name | string | `"cpn-console-server"` | Service account name. |
| server.startupProbe.enabled | bool | `true` | Whether or not enable the probe. |
| server.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| server.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before probe is initiated. |
| server.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| server.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| server.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| server.strategy.type | string | `"RollingUpdate"` | Strategy type used to replace old Pods by new ones, can be "Recreate" or "RollingUpdate". |
| server.tolerations | list | `[]` | Default tolerations for Console CPN server. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.13.1](https://github.com/norwoodj/helm-docs/releases/v1.13.1)
