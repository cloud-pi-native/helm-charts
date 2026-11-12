# Ticket #313 — retrait du legacy dans dso-console

## Périmètre validé
- [x] Charts de ce dépôt uniquement ; aucun dépôt consommateur modifié.
- [x] Conception validée ; version applicative cible v9.29.0, publiée après cette MR.
- [x] Plan écrit dans `docs/superpowers/plans/2026-11-12-dso-console-legacy-removal.md`.

## Implémentation
- [x] Retirer les templates server/strangler, valeurs et helpers dédiés.
- [x] Raccorder l'Ingress et la ConfigMap client au backend existant ; conserver le dépôt d'image server-nestjs.
- [x] Conserver client Nginx, Keycloak, PostgreSQL, CNPG, probes et entrypoint backend.
- [x] Router explicitement les documents Swagger JSON/YAML : leurs suffixes ne sont pas couverts par le Prefix Kubernetes de l'UI.
- [x] Ajouter 12 tests de rendu et leur exécution en CI, avec déclenchement sur modification des tests/workflow.
- [x] Documenter compatibilité, valeurs à migrer, contrat du contrôleur Ingress, backup et vérifications Prisma/données dans `charts/dso-console/UPGRADING.md`.
- [x] Version du chart 3.0.0 pour la rupture de valeurs/ressources. appVersion reste transitoirement v9.28.0 ; avertissement explicite de ne pas déployer avec les anciens tags. Association v9.29.0 ultérieure.
- [x] Régénérer README avec helm-docs 1.14.2 ; deuxième génération identique.

## Revue et preuves locales
- Helm 3.17.3 et helm-docs 1.14.2 téléchargés dans /tmp, archives vérifiées avec les checksums publiés ; aucun binaire ajouté au dépôt.
- Avant modification : `helm lint charts/dso-console` passe ; les tests détectent les ressources et routes legacy (échecs attendus, sans erreur d'exécution).
- Après modification : `python3 -B -m unittest discover -s ci/tests -v` : **12 tests OK**.
- `helm lint charts/dso-console` : **1 chart, 0 échec**.
- Comparaison avec afbc742 après normalisation des labels de version du chart : PostgreSQL par défaut **25 → 15** ressources, CNPG **22 → 12**, Keycloak activé **39 → 29**.
- Dans chaque scénario : seules 10 ressources legacy disparaissent ; seules la ConfigMap client, son checksum de déploiement et l'Ingress changent parmi les ressources conservées. Backend et stockage inchangés. Comparaisons faites en mode de rendu upgrade, pas sur un cluster.
- `git diff --check` passe. Aucune référence aux valeurs/helpers/images legacy ne reste dans les templates et valeurs dso-console.
- Revue locale du diff effectuée ; pas de revue indépendante par sous-agent (outil indisponible).

## Qualification différée, non revendiquée
- [ ] Publier/associer les images Console v9.29.0 après cette MR.
- [ ] Exécuter installation neuve et upgrade réel sur environnement dédié, migrations Prisma, conservation des données, authentification, headers volumineux, Swagger, streaming/WebSocket et réglages Ingress.
- Aucun cluster contacté ni déploiement effectué. Le ticket multi-dépôts ne peut pas être déclaré entièrement terminé avec cette seule contribution.
