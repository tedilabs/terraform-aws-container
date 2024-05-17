locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = "eks/${var.cluster_name}/iam-access"
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}


###################################################
# Node Access Entries
###################################################

# INFO: Not supported attributes
# - `user_name`
# - `kubernetes_groups`
resource "aws_eks_access_entry" "node" {
  for_each = {
    for entry in var.node_access_entries :
    entry.name => entry
  }

  cluster_name  = var.cluster_name
  type          = each.value.type
  principal_arn = each.value.principal

  tags = merge(
    {
      "Name" = each.key
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# User Access Entries
###################################################

resource "aws_eks_access_entry" "user" {
  for_each = {
    for entry in var.user_access_entries :
    entry.name => entry
  }

  cluster_name  = var.cluster_name
  type          = "STANDARD"
  principal_arn = each.value.principal

  user_name         = each.value.username
  kubernetes_groups = each.value.groups

  tags = merge(
    {
      "Name" = each.key
    },
    local.module_tags,
    var.tags,
  )
}
