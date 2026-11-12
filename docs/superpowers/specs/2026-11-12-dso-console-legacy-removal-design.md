# dso-console : backend NestJS unique (#313)

## Périmètre

Uniquement ce dépôt : chart dso-console, tests et documentation de migration. Aucun changement des dépôts consommateurs, aucune opération sur un cluster existant sans autorisation. Cette contribution ne suffit pas à clôturer les critères multi-dépôts et de qualification en cluster du ticket.

## Approche retenue

Retirer les templates `server` et `strangler`, leurs valeurs et helpers dédiés. Conserver les noms et sélecteurs du backend existant (`backend`) et son dépôt d'image `ghcr.io/cloud-pi-native/console/server-nestjs`. Conserver le client Nginx, l'Ingress, les dépendances PostgreSQL/Keycloak et la configuration CNPG.

Router `/api` et `/swagger-ui-server-nestjs` directement vers le service backend, sans réécriture du chemin. Ajouter deux routes Exact pour `/swagger-ui-server-nestjs-json` et `/swagger-ui-server-nestjs-yaml` : NestJS expose ces documents séparément et un Prefix Kubernetes sur le chemin de l'UI ne couvre pas leurs suffixes. Retirer la route Swagger du serveur supprimé. Raccorder les variables SERVER_HOST/SERVER_PORT du client au backend. Le Nginx client examiné ne fait que servir les fichiers statiques : ne pas lui ajouter un proxy inutile.

Alternative écartée : conserver un strangler de compatibilité ; cela maintiendrait une dépendance explicitement retirée. Autre alternative écartée : renommer backend en server ; cela provoquerait des remplacements de ressources sans nécessité.

## Compatibilité et migration

Le chart actuel est 2.4.50 avec appVersion v9.28.0. La version applicative cible, confirmée par le mainteneur, est v9.29.0 ; elle sera publiée après cette MR. Préparer le chart et documenter sa compatibilité avec v9.29.0 sans attendre cette publication pour soumettre la MR. Ne pas modifier appVersion vers un tag encore indisponible dans cette MR : l'association à v9.29.0 sera effectuée lors de la publication applicative. Signaler explicitement que l'appVersion v9.28.0 conservée transitoirement n'est pas compatible avec le nouveau routage complet et que le chart ne doit pas être déployé tel quel avec cette ancienne version. La qualification avec les images publiées v9.29.0 reste à effectuer après leur disponibilité.

Les personnalisations utiles de `server.*` doivent être reportées explicitement dans `backend.*` (environnement, secrets, ressources, volumes, plugins et identité Kubernetes). Les valeurs `strangler.*` n'ont plus d'effet. Documenter la suppression des ressources lors d'un upgrade et la nécessité de conserver les valeurs de base de données, secrets et volumes existants. Ne pas modifier les ressources de stockage.

Conserver l'entrypoint de l'image NestJS, qui exécute `npm run db:deploy` avant le serveur ; ne pas ajouter un second mécanisme de migration ni remplacer sa commande par défaut. Documenter le backup préalable et la vérification des migrations et des données après mise à niveau.

## Routage et sécurité

Conserver les annotations d'Ingress configurables. Examiner les réglages auparavant portés par strangler pour documenter ceux à reporter au contrôleur d'Ingress : WebSocket, en-têtes transmis, délais et buffers. Éviter d'imposer des annotations d'un contrôleur particulier dans un chart générique. Ne pas déclarer l'authentification ou les WebSocket qualifiés par un simple rendu Helm.

## Vérification

Ajouter des tests automatisés de rendu Helm : absence des ressources/images supprimées, destinations et ports des routes, configuration client, image et probes backend, absence de commande remplaçant les migrations. Couvrir les ports personnalisés, Ingress désactivé, autoscaling et configuration de base externe/CNPG. Intégrer les tests à la CI existante et régénérer la documentation des valeurs.

Exécuter les tests et le lint Helm avant de conclure. Le rendu avec d'anciennes valeurs permet de vérifier la structure attendue, mais ne constitue pas une qualification réelle d'upgrade. Les essais en cluster (installation neuve, authentification, API, Swagger, WebSocket, upgrade avec migrations et conservation des données) restent explicitement non prouvés tant qu'ils n'ont pas été exécutés dans un environnement dédié.
