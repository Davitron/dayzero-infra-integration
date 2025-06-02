locals {
  workspaces = {
    "mgnt" = "management-eks"
    "dev"  = "development-eks"
  }

  cluster_data = {
    for k, v in local.workspaces :
    k => {
      cluster_name                       = data.terraform_remote_state.workspaces[k].outputs.cluster_name
      cluster_endpoint                   = data.terraform_remote_state.workspaces[k].outputs.cluster_endpoint
      cluster_certificate_authority_data = data.aws_eks_cluster.clusters[k].certificate_authority[0].data
      cluster_mode                       = data.terraform_remote_state.workspaces[k].outputs.cluster_mode
      argocd_access_role                 = lookup(data.terraform_remote_state.workspaces[k].outputs, "argocd_access_role", "")
      cluster_alias                      = k
      labels                             =  {
        "awsAccountId" = data.terraform_remote_state.workspaces[k].outputs.account_id
        "clusterName"  = data.terraform_remote_state.workspaces[k].outputs.cluster_name
        "clusterMode"  = data.terraform_remote_state.workspaces[k].outputs.cluster_mode
        "region"       = data.terraform_remote_state.workspaces[k].outputs.region
        "clusterEndpoint" = data.terraform_remote_state.workspaces[k].outputs.cluster_endpoint
        "crossplaneIAMRole" = data.terraform_remote_state.workspaces[k].outputs.crossplane_iam_role
        "certManagerIAMRole" = data.terraform_remote_state.workspaces[k].outputs.certmanager_iam_role
        "externalDNSIAMRole" = data.terraform_remote_state.workspaces[k].outputs.external_dns_iam_role
        "vaultIAMRole" = data.terraform_remote_state.workspaces[k].outputs.vault_iam_role
      }
    } if data.terraform_remote_state.workspaces[k].outputs.cluster_mode == "workload"
  }
}
