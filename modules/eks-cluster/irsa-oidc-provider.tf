###################################################
# IRSA OIDC Provider
###################################################

module "oidc_provider" {
  source  = "tedilabs/account/aws//modules/iam-oidc-identity-provider"
  version = "~> 0.30.0"

  url       = aws_eks_cluster.this.identity[0].oidc[0].issuer
  audiences = ["sts.amazonaws.com"]

  auto_thumbprint_enabled = true

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
