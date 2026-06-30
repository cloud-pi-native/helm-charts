# implémente les règles de nommage des objets Kubernetes: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/
# (caractères alphanumériques minscules, et tirets / points)
# les noms des objets proviennent de noms de fichiers, donc il faut faire un peu de nettoyage:
#
# * un 1e replace/lower effectue des transformations (notez les parenthèses)
# * ensuite le regexReplaceAllLiteral efface les caractères non valides
# * enfin le trunc limite la taille à 253
{{- define "lib.grafana-dns-name" }}
{{- regexReplaceAllLiteral "[^a-z0-9\\-\\.]" ( . | lower | replace " " "-" | replace "_" "-") "" | trunc 253 }}
{{- end }}
