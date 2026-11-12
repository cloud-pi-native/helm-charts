# dso-console NestJS-only Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Retirer Fastify legacy et strangler du chart, en préparation de Console v9.29.0.

**Architecture:** Garder les ressources backend et client existantes ; raccorder directement l'Ingress au backend sans réécriture. Garder PostgreSQL, CNPG, Keycloak et les commandes de démarrage des images inchangés.

**Tech Stack:** Helm 3, Python unittest/PyYAML, helm-docs 1.14.2, GitHub Actions.

---

## Task 1 — Tests de rendu avant modification

**Files:** créer `ci/tests/test_dso_console.py`.

- [ ] Installer Helm dans un répertoire temporaire, sans modifier l'environnement global ; vérifier son archive avec le checksum publié.
- [ ] Exécuter un lint de référence : `helm lint charts/dso-console`.
- [ ] Créer des tests Python qui invoquent réellement `helm template console charts/dso-console`, analysent les documents YAML et désactivent les sous-charts pour isoler les ressources Console.
- [ ] Vérifier que les Deployments sont seulement client/backend et qu'aucune image legacy ni ressource issue des templates server/strangler ne subsiste.
- [ ] Vérifier les chemins `/`, `/api`, `/swagger-ui-server-nestjs`, leurs services et ports ; vérifier l'absence de `/swagger-ui-server`. Ajouter des règles Exact pour les documents Swagger `-json` et `-yaml` non couverts par le Prefix Kubernetes de l'UI.
- [ ] Couvrir les ports personnalisés, les annotations/TLS, plusieurs hôtes, Ingress désactivé, HPA et anciennes valeurs encore fournies.
- [ ] Vérifier les probes NestJS et l'absence de command/args remplaçant l'entrypoint ; préserver secrets DB/Keycloak, DB externe et secret CNPG.
- [ ] Lancer `python3 -m unittest discover -s ci/tests -v` et constater les échecs liés aux ressources et routes legacy avant implémentation.

## Task 2 — Retrait minimal du legacy

**Files:** supprimer `charts/dso-console/templates/server/*` et `templates/strangler/*` ; modifier `values.yaml`, `templates/_helpers.tpl`, `templates/ingress.yaml`, `templates/client/configmap.yaml`, `Chart.yaml`.

- [ ] Supprimer les deux répertoires de templates legacy.
- [ ] Retirer les sections racines `server` et `strangler` des valeurs et les helpers `cpnConsole.server.*` et `cpnConsole.strangler.*`.
- [ ] Dans l'Ingress, remplacer la variable de port strangler par `.Values.backend.service.port`, les destinations par `{{ $fullName }}-backend` et supprimer la route Swagger legacy et la variable server inutilisée.
- [ ] Dans la ConfigMap client, produire `SERVER_HOST: {{ include "cpnConsole.fullname" . }}-backend` et `SERVER_PORT: {{ .Values.backend.service.port | quote }}`.
- [ ] Passer la version du chart à 3.0.0 : suppression de valeurs et de ressources publiques incompatible. Conserver appVersion v9.28.0 transitoirement selon la séquence de publication convenue ; avertissement de non-déploiement avant association à v9.29.0.
- [ ] Relancer les tests, attendre PASS, puis `helm lint charts/dso-console`.

## Task 3 — Documentation et CI

**Files:** créer `charts/dso-console/README.md.gotmpl`, `charts/dso-console/UPGRADING.md` ; régénérer `README.md` ; modifier `.github/workflows/ci.yaml`.

- [ ] Ajouter un template helm-docs qui conserve la documentation standard et inclut un avertissement de compatibilité v9.29.0 ainsi qu'un lien vers UPGRADING.md.
- [ ] Documenter le transfert manuel de server.* vers backend.*, la suppression de strangler.*, les commandes d'images à préserver pour Prisma, la sauvegarde et les contrôles avant/après upgrade, les ressources supprimées et les données à conserver.
- [ ] Documenter le contrat de l'Ingress : chemins inchangés, HTTP/1.1 et WebSocket, Host/X-Forwarded-*, buffers de headers Keycloak (4 x 32k dans l'ancien proxy), streaming sans buffering et timeouts adaptés. Ne pas imposer un contrôleur particulier.
- [ ] Décrire séparément les preuves de rendu et les essais réels encore requis après publication v9.29.0, sans prétendre clôturer le ticket multi-dépôts.
- [ ] Ajouter au job lint-chart l'installation de `PyYAML==6.0.3` et la commande `python3 -m unittest discover -s ci/tests -v`.
- [ ] Régénérer avec helm-docs 1.14.2 et vérifier qu'une seconde génération ne change rien.

## Task 4 — Revue et preuves

- [ ] Exécuter les tests Python et `helm lint charts/dso-console` ; effectuer des rendus avec dépendances par défaut et en mode upgrade.
- [ ] Comparer les inventaires de ressources avant/après : seules les ressources server/strangler doivent disparaître ; les identités du backend et les stockages doivent rester stables.
- [ ] Examiner `git diff --check`, `git diff --stat`, et rechercher les références legacy actives dans les templates/valeurs.
- [ ] Mettre à jour `tasks/todo.md` avec les commandes et résultats ; signaler explicitement les essais en cluster non exécutés.
- [ ] Créer un commit d'implémentation avec le corps obligatoire : `Generated with AI assistance, reviewed by @stephanetrebel`.
