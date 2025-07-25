# cpn-ansible-job

![Version: 1.5.0](https://img.shields.io/badge/Version-1.5.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Creates Job for Socle services post-configuration.

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| cloud-pi-native | <cloudpinative-relations@interieur.gouv.fr> | <https://cloud-pi-native.fr> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| cronJob.create | bool | `false` | Create a cronJob. |
| cronJob.name | string | `""` | Playbook name if different from job. |
| cronJob.schedule | string | `"0 */6 * * *"` | CronJob schedule. |
| fullnameOverride | string | `""` | String to fully override the default application name. |
| global.platform | string | `"kubernetes"` | For security context depending of the cluster distribution. |
| job.activeDeadlineSeconds | string | `nil` | Optional maximum time in seconds before de Pod is killed (no matter of the backoffLimit) |
| job.annotations | object | `{"argocd.argoproj.io/hook":"PostSync","argocd.argoproj.io/hook-delete-policy":"HookSucceeded"}` | Kubernetes annotations to apply to the job resource. |
| job.backoffLimit | int | `6` | Number of retries before setting de Job status to failed |
| job.dscName | string | `nil` | Name of the DsoSocleConfig to use as source-of-truth |
| job.extraEnv | Optional | `[]` | Extra environment variables to pass to the job container |
| job.image.repository | string | `"ghcr.io/cloud-pi-native/git-ansible"` | Repository to use for the job. |
| job.image.tag | string | `""` | Tag to use for the job. # Overrides the image tag whose default is the chart appVersion. |
| job.name | string | `"example-playbook"` | Playbook name. |
| job.restartPolicy | string | `"OnFailure"` | Job restart policy (e.g., Never or OnFailure). |
| job.serviceAccount.annotations | object | `{}` | Annotations applied to created service account. |
| job.serviceAccount.create | bool | `true` | Create a service account for the job. |
| job.serviceAccount.name | string | `""` | Service account name. |
| job.targetRevision | string | `"main"` | Git branch or tag to checkout before applying the Ansible playbook |
| nameOverride | string | `""` | Provide a name in place of the default application name. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
