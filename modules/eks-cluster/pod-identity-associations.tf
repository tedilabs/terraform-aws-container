###################################################
# Pod Identity Associations
###################################################

resource "aws_eks_pod_identity_association" "this" {
  for_each = {
    for assoc in var.pod_identity_associations :
    "${assoc.namespace}/${assoc.service_account}" => assoc
  }

  region = var.region

  cluster_name = aws_eks_cluster.this.name

  namespace       = each.value.namespace
  service_account = each.value.service_account

  role_arn        = each.value.role
  target_role_arn = each.value.target_role

  disable_session_tags = !each.value.session_tagging_enabled
  tags = merge(
    {
      "Name" = each.key
    },
    local.module_tags,
    var.tags,
    each.value.tags,
  )
}
