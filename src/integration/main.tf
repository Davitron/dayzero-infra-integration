resource "helm_release" "argocd" {
  namespace        = "argocd"
  create_namespace = true
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "v7.8.14"
  replace          = false
  force_update     = false
  timeout          = 600

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      name,
      repository,
      chart,
      version,
      namespace,
      create_namespace,
      values,
      set,
      set_sensitive,
      timeout,
      dependency_update,
      disable_webhooks,
      force_update,
      recreate_pods,
      replace,
      cleanup_on_fail,
      atomic,
      wait,
      wait_for_jobs,
      render_subchart_notes,
      verify,
      lint,
      max_history,
      disable_openapi_validation,
      postrender,
      skip_crds
    ]
  }
}

# resource "kubectl_manifest" "platform_deployment_repo" {
#   yaml_body = <<-YAML
#   apiVersion: v1
#   kind: Secret
#   metadata:
#     name: "deployment-repos"
#     namespace: argocd
#     labels:
#       argocd.argoproj.io/secret-type: repo-creds
#   stringData:
#     type: git
#     url: https://github.com/Davtrion
#     password: ${var.github_token}
#     username: davitron
#   YAML
# }

resource "kubectl_manifest" "cluster_secret" {
  for_each = local.cluster_data
  yaml_body = templatefile("${path.module}/cluster-secret.yaml.tpl", {
    cluster_name     = each.value.cluster_name
    cluster_mode     = each.value.cluster_mode
    cluster_alias    = each.value.cluster_alias
    cluster_endpoint = each.value.cluster_endpoint
    config_json = jsonencode({
      awsAuthConfig = {
        clusterName = each.value.cluster_name
        roleARN     = each.value.argocd_access_role
      }
      tlsClientConfig = {
        insecure = false
        caData   = each.value.cluster_certificate_authority_data
      }
    })
  })
}
