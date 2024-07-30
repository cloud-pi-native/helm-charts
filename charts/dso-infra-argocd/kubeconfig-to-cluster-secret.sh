#!/bin/bash -e

usage() {
    echo "Usage: $0 -k <path_to_kubeconfig> -n <argo_cluster_name> [-c <context_name>] [-i <https://cluster_api_ip:443>]"
    echo "Si absent, 'context_name' vaut le contexte courant de la kubeconfig."
    echo "Si absent, 'cluster_api_ip' vaut la valeur du cluster.server de la kubeconfig."
    exit 1
}

while getopts "k:n:c:i:" opt; do
    case $opt in
        k) KUBECONFIG_PATH=$OPTARG ;;
        n) ARGOCD_CLUSTER_NAME=$OPTARG ;;
        c) CONTEXT_NAME=$OPTARG ;;
        i) CLUSTER_FIP=$OPTARG ;;
        *) usage ;;
    esac
done

# Test de la commande à utiliser : kubectl puis oc à défaut
CMD=kubectl
if ! command $CMD &>/dev/null; then
  CMD=oc
fi

# Vérifier que le fichier kubeconfig existe
if [ ! -f "$KUBECONFIG_PATH" ]; then
    echo "Le fichier kubeconfig spécifié n'existe pas: $KUBECONFIG_PATH."
    exit 1
fi

# Vérifier qu'un nom a été fourni
if [ -z "$ARGOCD_CLUSTER_NAME" ]; then
    echo "Veuillez fournir le nom du cluster tel qu'attendu dans ArgoCD."
    exit 1
fi

# Contexte par défaut
if [ -z "$CONTEXT_NAME" ]; then
    CONTEXT_NAME=$($CMD --kubeconfig="$KUBECONFIG_PATH" config current-context)
fi

# Extraire les informations nécessaires du fichier kubeconfig pour le contexte spécifié
CLUSTER_NAME=$($CMD --kubeconfig="$KUBECONFIG_PATH" config view -o jsonpath="{.contexts[?(@.name == \"$CONTEXT_NAME\")].context.cluster}")
SERVER_URL=${CLUSTER_FIP:-$($CMD --kubeconfig="$KUBECONFIG_PATH" config view -o jsonpath="{.clusters[?(@.name == \"$CLUSTER_NAME\")].cluster.server}")}
USER_NAME=$($CMD --kubeconfig="$KUBECONFIG_PATH" config view -o jsonpath="{.contexts[?(@.name == \"$CONTEXT_NAME\")].context.user}")
USER_CERT=$($CMD --kubeconfig="$KUBECONFIG_PATH" config view --raw -o jsonpath="{.users[?(@.name == \"$USER_NAME\")].user.client-certificate-data}")
USER_KEY=$($CMD --kubeconfig="$KUBECONFIG_PATH" config view --raw -o jsonpath="{.users[?(@.name == \"$USER_NAME\")].user.client-key-data}")
USER_TOKEN=$($CMD --kubeconfig="$KUBECONFIG_PATH" config view --raw -o jsonpath="{.users[?(@.name == \"$USER_NAME\")].user.token}")

# Vérifier que toutes les informations nécessaires ont été trouvées
if [ -z "$CLUSTER_NAME" ] || [ -z "$SERVER_URL" ] || [ -z "$USER_NAME" ] || ([ -z "$USER_CERT" ] || [ -z "$USER_KEY" ] && [ -z "$USER_TOKEN" ]); then
    echo "Impossible d'extraire les informations nécessaires du fichier kubeconfig pour le contexte : $CONTEXT_NAME"
    exit 1
fi

ARGOCD_CLUSTER_NAME=${ARGOCD_CLUSTER_NAME:-CLUSTER_NAME}

# Générer le fichier YAML de description de cluster pour ArgoCD
cat <<EOF > $ARGOCD_CLUSTER_NAME-cluster-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: $ARGOCD_CLUSTER_NAME-cluster-secret
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: $ARGOCD_CLUSTER_NAME
  server: $SERVER_URL
  config: |
EOF
if [ "$USER_TOKEN" ]; then
  cat <<EOF >> $ARGOCD_CLUSTER_NAME-cluster-secret.yaml
    {
      "bearerToken": "$USER_TOKEN"
    }
EOF
else
  cat <<EOF >> $ARGOCD_CLUSTER_NAME-cluster-secret.yaml
    {
      "tlsClientConfig": {
        "insecure": true,
        "certData": "$USER_CERT",
        "keyData": "$USER_KEY"
      }
    }
EOF
fi

echo "Le fichier $ARGOCD_CLUSTER_NAME-cluster-secret.yaml a été généré avec succès pour le contexte : $CONTEXT_NAME."

