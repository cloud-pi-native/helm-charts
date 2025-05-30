# cpn-cnpg

![Version: 2.3.1](https://img.shields.io/badge/Version-2.3.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm Chart to deploy easily a CNPG cluster

**Homepage:** <https://cloud-pi-native.fr>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| this-is-tobi | <thibault.colin@interieur.gouv.fr> | <https://this-is-tobi.com> |

## Source Code

* <https://github.com/cloud-pi-native/helm-charts>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://cloudnative-pg.github.io/charts | cnpg-operator(cloudnative-pg) | 0.23.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| annotations | object | `{}` | Additional cnpg cluster annotations. |
| backup.compression | string | `""` | Which compression algorithm should be used for cnpg backups (should be one of "gzip", "bzip2" or "snappy"). |
| backup.cron | string | `"0 0 */6 * * *"` | The cron rule used for cnpg backups. By default it runs every 6 hours. |
| backup.destinationPath | string | `""` | S3 destination path for cnpg backups (it should be set like `s3://<bucket_name>/<path>`). |
| backup.enabled | bool | `false` | Whether or not cnpg cluster deployment should be enabled. |
| backup.endpointCA.create | bool | `false` | Whether or not to create S3 CA kubernetes secret used for cnpg backups. It will use `secretName`, `accessKeyId.key`, `accessKeyId.value`, `secretAccessKey.key` and `secretAccessKey.value` to create the secret. |
| backup.endpointCA.key | string | `""` | The secret key containing S3 CA for cnpg backups. |
| backup.endpointCA.secretName | string | `""` | The secret name containing S3 CA for cnpg backups. |
| backup.endpointCA.value | string | `""` | The S3 certificate used for cnpg backups. Only needed if `backup.endpointCA.create` is set to `true`. |
| backup.endpointURL | string | `""` | S3 endpoint for cnpg backups. |
| backup.maxParallelWal | int | `8` | The number of parallel process that will be applied when applying wals. |
| backup.recoveryTarget | object | `{}` | Recovery target config to perform a point in time recovery when restore. |
| backup.retentionPolicy | string | `"14d"` | Retention policy for cnpg backups recurrences. |
| backup.s3Credentials.accessKeyId.key | string | `"accessKeyId"` | S3 accessKeyId kubernetes secret key used for cnpg backups. |
| backup.s3Credentials.accessKeyId.value | string | `""` | S3 accessKeyId value used for cnpg backups. Only needed if `backup.s3Credentials.create` is set to `true`. |
| backup.s3Credentials.create | bool | `false` | Whether or not to create S3 credentials kubernetes secret used for cnpg backups. It will use `secretName`, `accessKeyId.key`, `accessKeyId.value`, `secretAccessKey.key` and `secretAccessKey.value` to create the secret. |
| backup.s3Credentials.secretAccessKey.key | string | `"secretAccessKey"` | S3 secretAccessKey kubernetes secret key used for cnpg backups. |
| backup.s3Credentials.secretAccessKey.value | string | `""` | S3 secretAccessKey value used for cnpg backups. Only needed if `backup.s3Credentials.create` is set to `true`. |
| backup.s3Credentials.secretName | string | `""` | S3 kubernetes secret name used for cnpg backups. |
| cnpg-operator.enabled | bool | `false` | Whether or not cnpg operator should be deployed. |
| dbName | string | `"dbname"` | Name of the database. |
| enableSuperuserAccess | bool | `true` | Enable superuser access. |
| exposed | bool | `false` | Whether or not a NodePort service should be created to exposed the database. |
| fullnameOverride | string | `""` | String to fully override the default application name. |
| imageName | string | `""` | Name of the image used for database. By default (empty string), the operator will install the latest available minor version of the latest major version of PostgreSQL when the operator was released |
| imagePullSecrets | string | `""` | Name of the image pull secrets. |
| initSecret | object | `{"enabled":false,"password":"","secretName":"","username":""}` | Only when mode: "primary" to allow choice of database user and password. |
| instances | int | `3` | Number of instances to spawn in the cluster. |
| labels | object | `{}` | Additional cnpg cluster labels. |
| mode | string | `"primary"` | Mode used to deploy the cnpg cluster, it should be `primary`, `replica` or `restore`. |
| monitoring | object | `{"enabled":false,"podMonitorAdditionalLabels":{},"podMonitorMetricRelabelings":[],"podMonitorRelabelings":[]}` | Whether or not PodMonitor should be deployed. |
| monitoring.enabled | bool | `false` | Specifies whether the monitoring should be enabled. Requires Prometheus Operator CRDs. |
| monitoring.podMonitorAdditionalLabels | object | `{}` | Additional labels for the podMonitor |
| monitoring.podMonitorMetricRelabelings | list | `[]` | Metrics relabel configurations to apply to samples before ingestion. |
| monitoring.podMonitorRelabelings | list | `[]` | Relabel configurations to apply to samples before scraping. |
| nameOverride | string | `""` | Provide a name in place of the default application name. |
| nodePort | string | `nil` | Port used for NodePort service. Needs `exposed` tu be true. |
| parameters | object | `{}` | Customize Postgresql parameters. |
| pooler | object | `{"enabled":false,"instances":3,"parameters":{"default_pool_size":"100","max_client_conn":"1000"},"poolMode":"session"}` | CNPG Pooler configuration |
| pooler.enabled | bool | `false` | Enabling or disabling PgBouncer Pooler |
| pooler.instances | int | `3` | Number of PgBouncer pods |
| pooler.parameters | object | `{"default_pool_size":"100","max_client_conn":"1000"}` | Parameters to configure PgBouncer (see https://www.pgbouncer.org/config.html#section-databases) |
| pooler.poolMode | string | `"session"` | Type of PgBouncer connexion |
| primaryUpdateStrategy | string | `"unsupervised"` | Rolling update strategy used : unsupervised: automated update of the primary once all replicas have been upgraded (default) supervised: requires manual supervision to perform the switchover of the primary |
| pvcSize.data | string | `"10Gi"` | Size of the data PVC used by each cnpg instance. |
| pvcSize.wal | string | `"5Gi"` | Size of the WAL PVC used by each cnpg instance (if value is `null` then WAL files are stored within the data PVC). |
| replica.host | string | `""` | Primary cnpg cluster host used for replica mode. |
| replica.port | int | `5432` | Primary cnpg cluster port used for replica mode. |
| username | string | `"username"` | Username of the database user. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
