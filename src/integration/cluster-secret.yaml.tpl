apiVersion: v1
kind: Secret
metadata:
  name: "${cluster_name}"
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
    cluster_mode: "${cluster_mode}"
    env: "${cluster_alias}"
type: Opaque
stringData:
  name: "${cluster_name}"
  server: "${cluster_endpoint}"
  config: '${config_json}'
