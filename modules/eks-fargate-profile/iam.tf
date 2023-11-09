###################################################
# IAM Role for Fargate Profiles
###################################################

module "role" {
  count = var.default_pod_execution_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.27.0"

  name = coalesce(
    var.default_pod_execution_role.name,
    "eks-${var.cluster_name}-fargate-profile-${var.name}"
  )
  path        = var.default_pod_execution_role.path
  description = var.default_pod_execution_role.description

  trusted_service_policies = [
    {
      services = ["eks-fargate-pods.amazonaws.com"]
    }
  ]

  policies = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"]

  force_detach_policies  = true
  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
