# cpn-console

![Version: 2.3.8](https://img.shields.io/badge/Version-2.3.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 9.16.1](https://img.shields.io/badge/AppVersion-9.16.1-informational?style=flat-square)

A Helm chart to deploy Cloud Pi Native Console

**Homepage:** <https://cloud-pi-native.fr>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| omiladi | <cloudpinative-relations@interieur.gouv.fr> | <https://www.interieur.gouv.fr/> |
| KepoParis | <cloudpinative-relations@interieur.gouv.fr> | <https://www.interieur.gouv.fr/> |

## Source Code

* <https://github.com/cloud-pi-native/helm-charts>
* <https://github.com/cloud-pi-native/console>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | keycloak | 19.3.0 |
| https://charts.bitnami.com/bitnami | postgresql | 12.7.3 |
| https://cloudnative-pg.github.io/charts | cnpg-operator(cloudnative-pg) | 0.21.5 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| backend.affinity | object | `{}` | Default affinity for Console CPN backend. |
| backend.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the Console CPN backend. |
| backend.autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the Console CPN backend [HPA]. |
| backend.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the Console CPN backend [HPA]. |
| backend.autoscaling.targetCPUUtilizationPercentage | int | `80` | Average CPU utilization percentage for the Console CPN backend [HPA]. |
| backend.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average memory utilization percentage for the Console CPN backend [HPA]. |
| backend.container.args | list | `[]` | Console CPN backend container command args. |
| backend.container.command | list | `[]` | Console CPN backend container command. |
| backend.container.port | int | `3001` | Console CPN backend container port. |
| backend.container.securityContext | object | `{}` | Toggle and define container-level security context. |
| backend.dbDataCm | string | `""` | Name of the configmap with javascript data that need to be imported by the backend at start up. |
| backend.disabledPlugins | string | `""` | CSV list of plugins to disabled. |
| backend.env | object | `{}` | Console CPN backend container env variables, it will be injected into a configmap and loaded into the container. |
| backend.envFrom | list | `[]` | Console CPN backend container env variables loaded from configmap or secret reference. |
| backend.extraCa.key | string | `""` | The key to lookup. |
| backend.extraCa.mountSubPath | string | `"ca_certs"` | The path inside the container where the certificate file should be mount. This is a native Nodejs environment variable to extends certificates, see: https://nodejs.org/api/cli.html#node_extra_ca_certsfile. This mount path represent the subpath to use under the `/config` config root path. |
| backend.extraCa.name | string | `""` | The name of the configmap in namespace where certificates are stored. |
| backend.extraContainers | list | `[]` | Extra containers to add to the Console CPN backend pod as sidecars. |
| backend.extraVolumeMounts | list | `[]` | List of extra mounts to add (normally used with extraVolumes) |
| backend.extraVolumes | list | `[]` | List of extra volumes to add. |
| backend.fetchContainer.image | string | `"docker.io/wbitt/network-multitool:alpine-minimal"` | Image used to fetch plugins inside the initContainer. |
| backend.fetchContainer.pullPolicy | string | `"IfNotPresent"` | Image pull policy to fetch plugins inside the initContainer. |
| backend.healthcheckPath | string | `"/api/v1/healthz"` | Console CPN backend container healthcheck endpoint. |
| backend.hostAliases | list | `[]` | Host aliases that will be injected at pod-level into /etc/hosts. |
| backend.image.pullPolicy | string | `"Always"` | Image pull policy for the Console CPN backend. |
| backend.image.repository | string | `"ghcr.io/cloud-pi-native/console/server-nestjs"` | Repository to use for the Console CPN server. |
| backend.image.tag | string | `""` | Tag to use for the Console CPN backend. # Overrides the image tag whose default is the chart appVersion. |
| backend.initContainers | list | `[]` | Init containers to add to the Console CPN client pod. |
| backend.livenessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| backend.livenessProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| backend.livenessProbe.initialDelaySeconds | int | `30` | Whether or not enable the probe. |
| backend.livenessProbe.periodSeconds | int | `30` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| backend.livenessProbe.successThreshold | int | `1` | Number of seconds after the container has started before probe is initiated. |
| backend.livenessProbe.timeoutSeconds | int | `5` | How often (in seconds) to perform the probe. |
| backend.nodeSelector | object | `{}` | Default node selector for Console CPN backend. |
| backend.plugins | list | `[]` | List of zips to download; basically curl url, unzip and stores it in plugins/external/<dir_name>. |
| backend.podAnnotations | object | `{}` | Annotations for the Console CPN backend deployed pods. |
| backend.podLabels | object | `{}` | Labels for the Console CPN backend deployed pods. |
| backend.podSecurityContext | object | `{}` | Toggle and define pod-level security context. |
| backend.proxy.enabled | bool | `false` | Enable Proxy configuration for the plugins initContainer. |
| backend.proxy.env | list | `[{"name":"http_proxy","value":"http://proxy.example.com:3128"},{"name":"https_proxy","value":"http://proxy.example.com:3128"},{"name":"no_proxy","value":".cluster.local,.svc.cluster.local,.svc"}]` | Map of environment variables to inject into the plugins initContainers. |
| backend.readinessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| backend.readinessProbe.failureThreshold | int | `2` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| backend.readinessProbe.initialDelaySeconds | int | `15` | Number of seconds after the container has started before probe is initiated. |
| backend.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| backend.readinessProbe.successThreshold | int | `2` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| backend.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| backend.replicaCount | int | `1` | The number of application controller pods to run. |
| backend.resources.limits.cpu | string | `"500m"` | CPU limit for the Console CPN backend. |
| backend.resources.limits.memory | string | `"512Mi"` | Memory limit for the Console CPN backend. |
| backend.resources.requests.cpu | string | `"250m"` | CPU request for the Console CPN backend. |
| backend.resources.requests.memory | string | `"128Mi"` | Memory request for the Console CPN backend. |
| backend.secrets | object | `{}` | Console CPN backend container env secrets, it will be injected into a secret and loaded into the container. |
| backend.service.port | int | `80` | Console CPN backend service port. |
| backend.service.type | string | `"ClusterIP"` | Console CPN backend service type. |
| backend.serviceAccount.annotations | object | `{}` | Annotations applied to created service account. |
| backend.serviceAccount.create | bool | `true` | Create a service account for the Console CPN backend. |
| backend.serviceAccount.name | string | `"cpn-console-backend"` | Service account name. |
| backend.startupProbe.enabled | bool | `true` | Whether or not enable the probe. |
| backend.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| backend.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before probe is initiated. |
| backend.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| backend.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| backend.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| backend.strategy.type | string | `"RollingUpdate"` | Strategy type used to replace old Pods by new ones, can be "Recreate" or "RollingUpdate". |
| backend.tolerations | list | `[]` | Default tolerations for Console CPN backend. |
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
| client.envFrom | list | `[]` | Console CPN client container env variables loaded from configmap or secret reference. |
| client.extraContainers | list | `[]` | Extra containers to add to the Console CPN client pod as sidecars. |
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
| client.resources.limits.cpu | string | `"500m"` | CPU limit for the Console CPN client. |
| client.resources.limits.memory | string | `"512Mi"` | Memory limit for the Console CPN client. |
| client.resources.requests.cpu | string | `"250m"` | CPU request for the Console CPN client. |
| client.resources.requests.memory | string | `"128Mi"` | Memory request for the Console CPN client. |
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
| cnpg-operator.enabled | bool | `false` | Whether or not cnpg operator should be deployed. |
| cnpg.annotations | object | `{}` | Additional cnpg cluster annotations. |
| cnpg.backup.compression | string | `""` | Which compression algorithm should be used for cnpg backups (should be one of "gzip", "bzip2" or "snappy"). |
| cnpg.backup.cron | string | `"0 0 */6 * * *"` | The cron rule used for cnpg backups. By default it runs every 6 hours. |
| cnpg.backup.destinationPath | string | `""` | S3 destination path for cnpg backups (it should be set like `s3://<bucket_name>/<path>`). |
| cnpg.backup.enabled | bool | `false` | Whether or not cnpg cluster deployment should be enabled. |
| cnpg.backup.endpointCA.key | string | `""` | The secret key containing S3 CA for cnpg backups. |
| cnpg.backup.endpointCA.name | string | `""` | The secret name containing S3 CA for cnpg backups. |
| cnpg.backup.endpointURL | string | `""` | S3 endpoint for cnpg backups. |
| cnpg.backup.maxParallelWal | int | `8` | The number of parallel process that will be applied when applying wals. |
| cnpg.backup.recoveryTarget | object | `{}` | Recovery target config to perform a point in time recovery when restore. |
| cnpg.backup.retentionPolicy | string | `"30d"` | Retention policy for cnpg backups recurrences. |
| cnpg.backup.s3Credentials.accessKeyId.key | string | `"accessKeyId"` | S3 accessKeyId kubernetes secret key used for cnpg backups. |
| cnpg.backup.s3Credentials.accessKeyId.value | string | `""` | S3 accessKeyId value used for cnpg backups. Only needed if `backup.s3Credentials.create` is set to `true`. |
| cnpg.backup.s3Credentials.create | bool | `false` | Whether or not to create kuebernetes secret used for cnpg backups. It will use `name`, `accessKeyId.key`, `accessKeyId.value`, `secretAccessKey.key` and `secretAccessKey.value` to create the secret. |
| cnpg.backup.s3Credentials.secretAccessKey.key | string | `"secretAccessKey"` | S3 secretAccessKey kubernetes secret key used for cnpg backups. |
| cnpg.backup.s3Credentials.secretAccessKey.value | string | `""` | S3 secretAccessKey value used for cnpg backups. Only needed if `backup.s3Credentials.create` is set to `true`. |
| cnpg.backup.s3Credentials.secretName | string | `""` | S3 kuebernetes secret name used for cnpg backups. |
| cnpg.dbName | string | `"dso-console-db"` | Name of the database. |
| cnpg.enableSuperuserAccess | bool | `true` | Enable superuser access. |
| cnpg.enabled | bool | `false` | Whether or not cnpg cluster deployment should be enabled. |
| cnpg.exposed | bool | `false` | Whether or not a NodePort service should be created to exposed the database. |
| cnpg.imageName | string | `""` | Name of the image used for database. By default (empty string), the operator will install the latest available minor version of the latest major version of PostgreSQL when the operator was released |
| cnpg.instances | int | `3` | Number of instances to spawn in the cluster. |
| cnpg.labels | object | `{}` | Additional cnpg cluster labels. |
| cnpg.mode | string | `"primary"` | Mode used to deploy the cnpg cluster, it should be `primary`, `replica` or `restore`. |
| cnpg.nameOverride | string | `""` | Provide a name in place of the default cnpg cluster name. The cnpg operator adds the cluster name to S3's `destinationPath`, so it is necessary to provide the exact match of the main cluster when using `replica` or `restore` mode. |
| cnpg.nodePort | string | `nil` | Port used for NodePort service. Needs `exposed` tu be true. |
| cnpg.postgresWalMaxSlotKeepSize | string | `""` | Maximum size of WAL files that replication slots are allowed to retain in the pg_wal directory at checkpoint time. Default retains an unlimited amount of WAL files. See: https://cloudnative-pg.io/documentation/current/replication/#capping-the-wal-size-retained-for-replication-slots (Refer to postgresql.conf for memory units). |
| cnpg.primaryUpdateStrategy | string | `"unsupervised"` | Rolling update strategy used : unsupervised: automated update of the primary once all replicas have been upgraded (default) supervised: requires manual supervision to perform the switchover of the primary |
| cnpg.pvcSize | string | `"10Gi"` | Size of the data PVC used by each cnpg instance. |
| cnpg.replica.host | string | `""` | Primary cnpg cluster host used for replica mode. |
| cnpg.replica.port | int | `5432` | Primary cnpg cluster port used for replica mode. |
| cnpg.username | string | `"dso"` | Username of the database user. |
| cnpg.walPvcSize | string | `nil` | Size of the WAL PVC used by each cnpg instance (if value is `null` then WAL files are stored within the data PVC). |
| config.create | bool | `false` | Whether or not helm should create the console config. |
| config.name | string | `"dso-config"` | Name of the generated config. |
| config.projectsRootDir | string | `"forge"` | Projects root directory to use in other services such as Gitlab, etc. |
| config.secrets | object | `{}` | Secrets to inject into the configuration. It is needed for the backend to get services informations such as urls, admin username, admin password or token, etc. |
| features | object | `{"vaultSecrets":{"enabled":true}}` | Set of feature settings - experimental |
| features.vaultSecrets | object | `{"enabled":true}` | vault secrets support |
| features.vaultSecrets.enabled | bool | `true` | enabling vault secret |
| fullnameOverride | string | `""` | String to fully override the default application name. |
| global.env | object | `{"NODE_ENV":"production"}` | Map of environment variables to inject into backend and frontend containers. |
| global.keycloak.clientIds.backend | string | `"console-backend"` | Keycloak clientId used for Console CPN backend. |
| global.keycloak.clientIds.frontend | string | `"console-frontend"` | Keycloak clientId used for Console CPN client. |
| global.keycloak.clientSecrets.backend | string | `""` | Keycloak clientSecret used for Console CPN backend. |
| global.keycloak.devRealm | bool | `false` | Whether or not to deploy the keycloak dev realm into a configmap named `keycloak-realm-dev`. |
| global.keycloak.domain.backend | string | `"keycloak.namespace.svc.cluster.local"` | Keycloak domain used for Console CPN backend. |
| global.keycloak.domain.frontend | string | `"keycloak.domain.com"` | Keycloak domain used for Console CPN client. |
| global.keycloak.protocol.backend | string | `"http"` | Keycloak protocol used for Console CPN backend. |
| global.keycloak.protocol.frontend | string | `"https"` | Keycloak protocol used for Console CPN client. |
| global.keycloak.realm | string | `"cloud-pi-native"` | Name of the keycloak realm used for authentication. |
| global.keycloak.redirectUri | string | `"https://console.dso.local"` | Keycloak redirect uri used with keycloak. |
| global.keycloak.sessionSecret | string | `"a-very-strong-secret-with-more-than-32-char"` | Session secret used to store keycloak session for Console CPN client. |
| global.postgresql.cnpgSecretName | string | `""` | Name of the secret to use to connect to external CNPG-managed DB |
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
| keycloak.auth.adminPassword | string | `"default"` |  |
| keycloak.auth.adminUser | string | `"default"` |  |
| keycloak.enabled | bool | `false` |  |
| keycloak.image.repository | string | `"bitnamilegacy/keycloak"` |  |
| keycloak.ingress.annotations | object | `{}` |  |
| keycloak.ingress.enabled | bool | `true` |  |
| keycloak.ingress.hostname | string | `"keycloak.dso.local"` |  |
| keycloak.ingress.ingressClassName | string | `""` |  |
| keycloak.ingress.path | string | `"/"` |  |
| keycloak.ingress.secrets | list | `[]` |  |
| keycloak.ingress.tls | bool | `false` |  |
| keycloak.nameOverride | string | `"cpn-keycloak"` |  |
| keycloak.postgresql.auth.architecture | string | `"standalone"` |  |
| keycloak.postgresql.auth.database | string | `"default"` |  |
| keycloak.postgresql.auth.password | string | `"default"` |  |
| keycloak.postgresql.auth.postgresPassword | string | `"default"` |  |
| keycloak.postgresql.auth.username | string | `"default"` |  |
| keycloak.postgresql.enabled | bool | `true` |  |
| keycloak.postgresql.image.repository | string | `"bitnamilegacy/postgresql"` |  |
| keycloak.postgresql.nameOverride | string | `"cpn-keycloak-db"` |  |
| keycloak.postgresql.primary.persistence.size | string | `"1Gi"` |  |
| keycloak.postgresql.primary.resources.limits.cpu | string | `"500m"` |  |
| keycloak.postgresql.primary.resources.limits.memory | string | `"512Mi"` |  |
| keycloak.postgresql.primary.resources.requests.cpu | string | `"250m"` |  |
| keycloak.postgresql.primary.resources.requests.memory | string | `"128Mi"` |  |
| keycloak.postgresql.primary.service.ports.postgresql | int | `5432` |  |
| keycloak.postgresql.primary.service.type | string | `"ClusterIP"` |  |
| keycloak.postgresql.readReplicas.persistence.size | string | `"1Gi"` |  |
| keycloak.production | bool | `true` |  |
| keycloak.proxy | string | `"edge"` |  |
| keycloak.tls.autoGenerated | bool | `false` |  |
| keycloak.tls.enabled | bool | `false` |  |
| nameOverride | string | `""` | Provide a name in place of the default application name. |
| postgresql.architecture | string | `"standalone"` |  |
| postgresql.auth.database | string | `"default"` |  |
| postgresql.auth.password | string | `"default"` |  |
| postgresql.auth.postgresPassword | string | `"default"` |  |
| postgresql.auth.username | string | `"default"` |  |
| postgresql.enabled | bool | `true` |  |
| postgresql.image.repository | string | `"bitnamilegacy/postgresql"` |  |
| postgresql.nameOverride | string | `"cpn-console-db"` |  |
| postgresql.primary.persistence.size | string | `"1Gi"` |  |
| postgresql.primary.resources.limits.cpu | string | `"500m"` |  |
| postgresql.primary.resources.limits.memory | string | `"512Mi"` |  |
| postgresql.primary.resources.requests.cpu | string | `"250m"` |  |
| postgresql.primary.resources.requests.memory | string | `"128Mi"` |  |
| postgresql.primary.service.ports.postgresql | int | `5432` |  |
| postgresql.primary.service.type | string | `"ClusterIP"` |  |
| postgresql.readReplicas.persistence.size | string | `"1Gi"` |  |
| server | object | `{"affinity":{},"autoscaling":{"enabled":false,"maxReplicas":3,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80},"container":{"args":[],"command":[],"port":8080,"securityContext":{}},"dbDataCm":"","disabledPlugins":"","env":{},"envFrom":[],"extraCa":{"key":"","mountSubPath":"ca_certs","name":""},"extraContainers":[],"extraVolumeMounts":[],"extraVolumes":[],"fetchContainer":{"image":"docker.io/wbitt/network-multitool:alpine-minimal","pullPolicy":"IfNotPresent"},"healthcheckPath":"/api/v1/healthz","hostAliases":[],"image":{"pullPolicy":"Always","repository":"ghcr.io/cloud-pi-native/console/server","tag":""},"initContainers":[],"livenessProbe":{"enabled":true,"failureThreshold":3,"initialDelaySeconds":30,"periodSeconds":30,"successThreshold":1,"timeoutSeconds":5},"nodeSelector":{},"plugins":[],"podAnnotations":{},"podLabels":{},"podSecurityContext":{},"proxy":{"enabled":false,"env":[{"name":"http_proxy","value":"http://proxy.example.com:3128"},{"name":"https_proxy","value":"http://proxy.example.com:3128"},{"name":"no_proxy","value":".cluster.local,.svc.cluster.local,.svc"}]},"readinessProbe":{"enabled":true,"failureThreshold":2,"initialDelaySeconds":15,"periodSeconds":10,"successThreshold":2,"timeoutSeconds":5},"replicaCount":1,"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"128Mi"}},"secrets":{},"service":{"port":80,"type":"ClusterIP"},"serviceAccount":{"annotations":{},"create":true,"name":"cpn-console-server"},"startupProbe":{"enabled":true,"failureThreshold":10,"initialDelaySeconds":0,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5},"strategy":{"type":"RollingUpdate"},"tolerations":[]}` | DEPRECATED. Will be progressively replaced by `backend` |
| server.affinity | object | `{}` | Default affinity for Console CPN backend. |
| server.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the Console CPN backend. |
| server.autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the Console CPN backend [HPA]. |
| server.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the Console CPN backend [HPA]. |
| server.autoscaling.targetCPUUtilizationPercentage | int | `80` | Average CPU utilization percentage for the Console CPN backend [HPA]. |
| server.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average memory utilization percentage for the Console CPN backend [HPA]. |
| server.container.args | list | `[]` | Console CPN backend container command args. |
| server.container.command | list | `[]` | Console CPN backend container command. |
| server.container.port | int | `8080` | Console CPN backend container port. |
| server.container.securityContext | object | `{}` | Toggle and define container-level security context. |
| server.dbDataCm | string | `""` | Name of the configmap with javascript data that need to be imported by the backend at start up. |
| server.disabledPlugins | string | `""` | CSV list of plugins to disabled. |
| server.env | object | `{}` | Console CPN backend container env variables, it will be injected into a configmap and loaded into the container. |
| server.envFrom | list | `[]` | Console CPN backend container env variables loaded from configmap or secret reference. |
| server.extraCa.key | string | `""` | The key to lookup. |
| server.extraCa.mountSubPath | string | `"ca_certs"` | The path inside the container where the certificate file should be mount. This is a native Nodejs environment variable to extends certificates, see: https://nodejs.org/api/cli.html#node_extra_ca_certsfile. This mount path represent the subpath to use under the `/config` config root path. |
| server.extraCa.name | string | `""` | The name of the configmap in namespace where certificates are stored. |
| server.extraContainers | list | `[]` | Extra containers to add to the Console CPN backend pod as sidecars. |
| server.extraVolumeMounts | list | `[]` | List of extra mounts to add (normally used with extraVolumes) |
| server.extraVolumes | list | `[]` | List of extra volumes to add. |
| server.fetchContainer.image | string | `"docker.io/wbitt/network-multitool:alpine-minimal"` | Image used to fetch plugins inside the initContainer. |
| server.fetchContainer.pullPolicy | string | `"IfNotPresent"` | Image pull policy to fetch plugins inside the initContainer. |
| server.healthcheckPath | string | `"/api/v1/healthz"` | Console CPN backend container healthcheck endpoint. |
| server.hostAliases | list | `[]` | Host aliases that will be injected at pod-level into /etc/hosts. |
| server.image.pullPolicy | string | `"Always"` | Image pull policy for the Console CPN backend. |
| server.image.repository | string | `"ghcr.io/cloud-pi-native/console/server"` | Repository to use for the Console CPN backend. |
| server.image.tag | string | `""` | Tag to use for the Console CPN backend. # Overrides the image tag whose default is the chart appVersion. |
| server.initContainers | list | `[]` | Init containers to add to the Console CPN client pod. |
| server.livenessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| server.livenessProbe.failureThreshold | int | `3` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| server.livenessProbe.initialDelaySeconds | int | `30` | Whether or not enable the probe. |
| server.livenessProbe.periodSeconds | int | `30` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| server.livenessProbe.successThreshold | int | `1` | Number of seconds after the container has started before probe is initiated. |
| server.livenessProbe.timeoutSeconds | int | `5` | How often (in seconds) to perform the probe. |
| server.nodeSelector | object | `{}` | Default node selector for Console CPN backend. |
| server.plugins | list | `[]` | List of zips to download; basically curl url, unzip and stores it in plugins/external/<dir_name>. |
| server.podAnnotations | object | `{}` | Annotations for the Console CPN backend deployed pods. |
| server.podLabels | object | `{}` | Labels for the Console CPN backend deployed pods. |
| server.podSecurityContext | object | `{}` | Toggle and define pod-level security context. |
| server.proxy.enabled | bool | `false` | Enable Proxy configuration for the plugins initContainer. |
| server.proxy.env | list | `[{"name":"http_proxy","value":"http://proxy.example.com:3128"},{"name":"https_proxy","value":"http://proxy.example.com:3128"},{"name":"no_proxy","value":".cluster.local,.svc.cluster.local,.svc"}]` | Map of environment variables to inject into the plugins initContainers. |
| server.readinessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| server.readinessProbe.failureThreshold | int | `2` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| server.readinessProbe.initialDelaySeconds | int | `15` | Number of seconds after the container has started before probe is initiated. |
| server.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| server.readinessProbe.successThreshold | int | `2` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| server.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| server.replicaCount | int | `1` | The number of application controller pods to run. |
| server.resources.limits.cpu | string | `"500m"` | CPU limit for the Console CPN backend. |
| server.resources.limits.memory | string | `"512Mi"` | Memory limit for the Console CPN backend. |
| server.resources.requests.cpu | string | `"250m"` | CPU request for the Console CPN backend. |
| server.resources.requests.memory | string | `"128Mi"` | Memory request for the Console CPN backend. |
| server.secrets | object | `{}` | Console CPN backend container env secrets, it will be injected into a secret and loaded into the container. |
| server.service.port | int | `80` | Console CPN backend service port. |
| server.service.type | string | `"ClusterIP"` | Console CPN backend service type. |
| server.serviceAccount.annotations | object | `{}` | Annotations applied to created service account. |
| server.serviceAccount.create | bool | `true` | Create a service account for the Console CPN backend. |
| server.serviceAccount.name | string | `"cpn-console-server"` | Service account name. |
| server.startupProbe.enabled | bool | `true` | Whether or not enable the probe. |
| server.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| server.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before probe is initiated. |
| server.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| server.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| server.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| server.strategy.type | string | `"RollingUpdate"` | Strategy type used to replace old Pods by new ones, can be "Recreate" or "RollingUpdate". |
| server.tolerations | list | `[]` | Default tolerations for Console CPN backend. |
| strangler.affinity | object | `{}` | Default affinity for Console CPN strangler. |
| strangler.autoscaling.enabled | bool | `false` | Enable Horizontal Pod Autoscaler ([HPA]) for the Console CPN strangler. |
| strangler.autoscaling.maxReplicas | int | `3` | Maximum number of replicas for the Console CPN strangler [HPA]. |
| strangler.autoscaling.minReplicas | int | `1` | Minimum number of replicas for the Console CPN strangler [HPA]. |
| strangler.autoscaling.targetCPUUtilizationPercentage | int | `80` | Average CPU utilization percentage for the Console CPN strangler [HPA]. |
| strangler.autoscaling.targetMemoryUtilizationPercentage | int | `80` | Average memory utilization percentage for the Console CPN strangler [HPA]. |
| strangler.container.args | list | `[]` | Console CPN strangler container command args. |
| strangler.container.command | list | `[]` | Console CPN strangler container command. |
| strangler.container.port | int | `8080` | Console CPN strangler container port. |
| strangler.container.securityContext | object | `{}` | Toggle and define container-level security context. |
| strangler.env | object | `{}` | Console CPN strangler container env variables, it will be injected into a configmap and loaded into the container. |
| strangler.envFrom | list | `[]` | Console CPN strangler container env variables loaded from configmap or secret reference. |
| strangler.extraContainers | list | `[]` | Extra containers to add to the Console CPN strangler pod as sidecars. |
| strangler.extraVolumeMounts | list | `[]` | List of extra mounts to add (normally used with extraVolumes). |
| strangler.extraVolumes | list | `[]` | List of extra volumes to add. |
| strangler.healthcheckPath | string | `"/health"` | Console CPN strangler container healthcheck endpoint. |
| strangler.hostAliases | list | `[]` | Host aliases that will be injected at pod-level into /etc/hosts. |
| strangler.image.pullPolicy | string | `"Always"` | Image pull policy for the Console CPN strangler. |
| strangler.image.repository | string | `"ghcr.io/cloud-pi-native/console/nginx-strangler"` | Repository to use for the Console CPN strangler. |
| strangler.image.tag | string | `""` | Tag to use for the Console CPN strangler. # Overrides the image tag whose default is the chart appVersion. |
| strangler.initContainers | list | `[]` | Init containers to add to the Console CPN strangler pod. |
| strangler.livenessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| strangler.livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| strangler.livenessProbe.initialDelaySeconds | int | `30` | Number of seconds after the container has started before probe is initiated. |
| strangler.livenessProbe.periodSeconds | int | `30` | How often (in seconds) to perform the probe. |
| strangler.livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| strangler.livenessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out |
| strangler.nodeSelector | object | `{}` | Default node selector for Console CPN strangler. |
| strangler.podAnnotations | object | `{}` | Annotations for the Console CPN strangler deployed pods. |
| strangler.podLabels | object | `{}` | Labels for the Console CPN strangler deployed pods. |
| strangler.podSecurityContext | object | `{}` | Toggle and define pod-level security context. |
| strangler.readinessProbe.enabled | bool | `true` | Whether or not enable the probe. |
| strangler.readinessProbe.failureThreshold | int | `2` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| strangler.readinessProbe.initialDelaySeconds | int | `15` | Number of seconds after the container has started before probe is initiated. |
| strangler.readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| strangler.readinessProbe.successThreshold | int | `2` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| strangler.readinessProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| strangler.replicaCount | int | `1` | The number of application controller pods to run. |
| strangler.resources.limits.cpu | string | `"500m"` | CPU limit for the Console CPN strangler. |
| strangler.resources.limits.memory | string | `"512Mi"` | Memory limit for the Console CPN strangler. |
| strangler.resources.requests.cpu | string | `"250m"` | CPU request for the Console CPN strangler. |
| strangler.resources.requests.memory | string | `"128Mi"` | Memory request for the Console CPN strangler. |
| strangler.secrets | object | `{}` | Console CPN strangler container env secrets, it will be injected into a secret and loaded into the container. |
| strangler.service.port | int | `80` | Console CPN strangler service port. |
| strangler.service.type | string | `"ClusterIP"` | Console CPN strangler service type. |
| strangler.startupProbe.enabled | bool | `true` | Whether or not enable the probe. |
| strangler.startupProbe.failureThreshold | int | `10` | Minimum consecutive failures for the probe to be considered failed after having succeeded. |
| strangler.startupProbe.initialDelaySeconds | int | `0` | Number of seconds after the container has started before probe is initiated. |
| strangler.startupProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe. |
| strangler.startupProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed. |
| strangler.startupProbe.timeoutSeconds | int | `5` | Number of seconds after which the probe times out. |
| strangler.strategy.type | string | `"RollingUpdate"` | Strategy type used to replace old Pods by new ones, can be "Recreate" or "RollingUpdate". |
| strangler.tolerations | list | `[]` | Default tolerations for Console CPN strangler. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
