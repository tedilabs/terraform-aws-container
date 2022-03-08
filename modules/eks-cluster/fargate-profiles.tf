###################################################
# Fargate Profiles
###################################################

resource "aws_eks_fargate_profile" "this" {
  for_each = {
    for profile in var.fargate_profiles :
    profile.name => profile
  }

  fargate_profile_name = each.key

  cluster_name           = aws_eks_cluster.this.name
  pod_execution_role_arn = module.role__fargate_profile.arn
  subnet_ids = coalescelist(
    try(each.value.subnet_ids, []),
    var.fargate_default_subnet_ids,
    var.subnet_ids,
  )

  dynamic "selector" {
    for_each = each.value.selectors

    content {
      namespace = selector.value.namespace
      labels    = try(selector.value.labels, {})
    }
  }

  tags = merge(
    {
      "Name" = each.key
    },
    local.module_tags,
    var.tags,
  )
}
