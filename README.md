# CPiN Charts

## Description

Ce dépôt héberge les Helm Charts développés et maintenus par Cloud Pi Native.

Il expose également un Helm Repository sur [cloud-pi-native.github.io/helm-charts](https://cloud-pi-native.github.io/helm-charts/index.yaml) grâce à Github Pages et la Github Action [chart releaser](https://github.com/helm/chart-releaser-action).

## Contribution

- À chaque PR est associé un pipeline qui vérifie le lint + helm-docs
- Lors du merge sur _main_ le pipeline de release publie la nouvelle version du ou des charts impactés et met à jour le Helm Repo (branche _gh-pages_).

> [!NOTE]
> La version dans le fichier `Chart.yaml` doit être modifiée avant le merge sur main sous peine d'une erreur lors du pipeline de release pour doublon de version.

Exemple de commande pour mettre à jour la console

`docker run --rm --volume "$(pwd)/charts/dso-console:/helm-docs" -u $(id -u) jnorwood/helm-docs:latest`

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
