###################################################
# Associations of OIDC Identity Provider
###################################################

resource "aws_eks_identity_provider_config" "this" {
  for_each = {
    for provider in var.oidc_identity_providers :
    provider.name => provider
  }

  region = var.region

  cluster_name = aws_eks_cluster.this.name

  oidc {
    identity_provider_config_name = each.key

    issuer_url = each.value.issuer_url
    client_id  = each.value.client_id

    required_claims = each.value.required_claims
    username_claim  = each.value.username_claim
    username_prefix = each.value.username_prefix
    groups_claim    = each.value.groups_claim
    groups_prefix   = each.value.groups_prefix
  }

  tags = merge(
    {
      "Name" = "${local.metadata.name}/${each.key}"
    },
    local.module_tags,
    var.tags,
  )
}
