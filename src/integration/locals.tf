locals {
  workspaces = {
    "mgnt" = "management-eks"
    "dev"  = "development-eks"
  }

  cluster_data = {
    for k, v in local.workspaces : 
    k => {
      cluster_mode = data.terraform_remote_state.workspaces[k].outputs.cluster_mode
      cluster_name = data.terraform_remote_state.workspaces[k].outputs.cluster_mode == "workload" ? data.terraform_remote_state.workspaces[k].outputs.cluster_name : "in-cluster"
      cluster_endpoint = data.terraform_remote_state.workspaces[k].outputs.cluster_mode == "workload" ? data.terraform_remote_state.workspaces[k].outputs.cluster_endpoint : "https://kubernetes.default.svc"

      cluster_certificate_authority_data = data.aws_eks_cluster.clusters[k].certificate_authority[0].data
      argocd_access_role                 = lookup(data.terraform_remote_state.workspaces[k].outputs, "argocd_access_role", "")
      cluster_alias                      = k

      annotations = {
        awsAccountId       = data.terraform_remote_state.workspaces[k].outputs.account_id
        clusterName        = data.terraform_remote_state.workspaces[k].outputs.cluster_name
        clusterMode        = data.terraform_remote_state.workspaces[k].outputs.cluster_mode
        region             = data.terraform_remote_state.workspaces[k].outputs.region
        clusterEndpoint    = data.terraform_remote_state.workspaces[k].outputs.cluster_endpoint
        crossplaneIAMRole  = data.terraform_remote_state.workspaces[k].outputs.crossplane_iam_role
        certManagerIAMRole = data.terraform_remote_state.workspaces[k].outputs.certmanager_iam_role
        externalDNSIAMRole = data.terraform_remote_state.workspaces[k].outputs.external_dns_iam_role
        vaultIAMRole       = try(data.terraform_remote_state.workspaces[k].outputs.vault_iam_role, "not_set")
      }

      config_json = data.terraform_remote_state.workspaces[k].outputs.cluster_mode == "workload" ? jsonencode({
        awsAuthConfig = {
          clusterName = data.terraform_remote_state.workspaces[k].outputs.cluster_name
          roleARN     = data.terraform_remote_state.workspaces[k].outputs.argocd_access_role
        }
        tlsClientConfig = {
          insecure = false
          caData   = data.aws_eks_cluster.clusters[k].certificate_authority[0].data
        }
      }) : jsonencode({
        tlsClientConfig = {
          insecure = false
        }
      })
    }
  }
}
