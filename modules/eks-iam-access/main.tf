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
# - `kubernetes_username`
# - `kubernetes_groups`
module "node" {
  for_each = {
    for entry in var.node_access_entries :
    entry.name => entry
  }

  source = "../eks-access-entry"

  name         = each.key
  cluster_name = var.cluster_name
  type         = each.value.type
  principal    = each.value.principal

  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

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

module "user" {
  for_each = {
    for entry in var.user_access_entries :
    entry.name => entry
  }

  source = "../eks-access-entry"

  name         = each.key
  cluster_name = var.cluster_name
  type         = "STANDARD"
  principal    = each.value.principal

  kubernetes_username = each.value.kubernetes_username
  kubernetes_groups   = each.value.kubernetes_groups
  kubernetes_permissions = [
    for permission in each.value.kubernetes_permissions : {
      policy     = permission.policy
      scope      = permission.scope
      namespaces = permission.namespaces
    }
  ]

  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    {
      "Name" = each.key
    },
    local.module_tags,
    var.tags,
  )
}
