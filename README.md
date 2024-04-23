# CPiN Charts

## Description

Ce dépôt héberge les Helm Charts développés et maintenus par Cloud Pi Native.

Il expose également un Helm Repository sur [cloud-pi-native.github.io/helm-charts](https://cloud-pi-native.github.io/helm-charts/index.yaml) grâce à Github Pages et la Github Action [chart releaser](https://github.com/helm/chart-releaser-action).


## Utilisation

### CLI
```sh
helm repo add cpin https://cloud-pi-native.github.io/helm-charts
helm search repo dso
helm install dso-env cpin/dso-env
```

### ArgoCD

```yaml
[...]
sources:
- repoURL: https://github.com/cloud-pi-native/helm-charts.git
    targetRevision: dso-env-1.0.0
    path: charts/dso-env
```
