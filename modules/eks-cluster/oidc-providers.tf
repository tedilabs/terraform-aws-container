###################################################
# Associations of OIDC Identity Provider
###################################################

resource "aws_eks_identity_provider_config" "this" {
  for_each = {
    for provider in var.oidc_identity_providers :
    provider.name => provider
  }

  cluster_name = aws_eks_cluster.this.name

  oidc {
    identity_provider_config_name = each.key

    issuer_url = each.value.issuer_url
    client_id  = each.value.client_id

    required_claims = try(each.value.required_claims, null)
    username_claim  = try(each.value.username_claim, null)
    username_prefix = try(each.value.username_prefix, null)
    groups_claim    = try(each.value.groups_claim, null)
    groups_prefix   = try(each.value.groups_prefix, null)
  }

  tags = merge(
    {
      "Name" = "${local.metadata.name}/${each.key}"
    },
    local.module_tags,
    var.tags,
  )
}
