apiVersion: v1
kind: Secret
metadata:
  name: "${cluster_name}"
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: cluster
    cluster_mode: "${cluster_mode}"
    env: "${cluster_alias}"
  annotations:
%{ for k, v in cluster_annotations ~}
    ${k}: "${v}"
%{ endfor ~}
type: Opaque
stringData:
  name: "${cluster_name}"
  server: "${cluster_endpoint}"
  config: '${config_json}'
