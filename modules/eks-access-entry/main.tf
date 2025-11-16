locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = "${var.cluster_name}/${var.name}"
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
# Access Entry
###################################################

resource "aws_eks_access_entry" "this" {
  region = var.region

  cluster_name  = var.cluster_name
  type          = var.type
  principal_arn = var.principal

  user_name = (var.type == "STANDARD"
    ? var.kubernetes_username
    : null
  )
  kubernetes_groups = (var.type == "STANDARD"
    ? var.kubernetes_groups
    : null
  )

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = var.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Access Poilcy for Standard Access Entry
###################################################

resource "aws_eks_access_policy_association" "this" {
  for_each = {
    for permission in var.kubernetes_permissions :
    trimprefix("arn:aws:eks::aws:cluster-access-policy/", permission.policy) => permission
  }

  region = var.region

  cluster_name  = aws_eks_access_entry.this.cluster_name
  principal_arn = aws_eks_access_entry.this.principal_arn

  policy_arn = each.value.policy

  access_scope {
    type       = lower(each.value.scope)
    namespaces = each.value.namespaces
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}
