locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
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
# EKS Fargate Profiles
###################################################

resource "aws_eks_fargate_profile" "this" {
  region = var.region

  cluster_name         = var.cluster_name
  fargate_profile_name = var.name

  subnet_ids = var.subnets

  pod_execution_role_arn = (var.default_pod_execution_role.enabled
    ? module.role[0].arn
    : var.pod_execution_role
  )

  dynamic "selector" {
    for_each = var.selectors

    content {
      namespace = selector.value.namespace
      labels    = selector.value.labels
    }
  }

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
