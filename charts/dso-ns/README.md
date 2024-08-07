# dso-ns

![Version: 1.0.1](https://img.shields.io/badge/Version-1.0.1-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

A Helm chart to create all the necessary resources for deploying applications by the DSO console (namespace, secrets, quota, ...).

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| this-is-tobi | <thibault.colin@interieur.gouv.fr> | <https://this-is-tobi.com> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| application.destination.namespace | string | `"app1"` | Nom du namespace applicatif cible |
| application.quota.cpu | int | `nil` | Quota CPU pour le namespace |
| application.quota.memory | string | `nil` | Quota mémoire pour le namespace |
| commonLabels | object | `{}` | Labels appliqués sur les différents objets |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
