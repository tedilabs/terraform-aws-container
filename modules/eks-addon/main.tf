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
# EKS Addon
###################################################

resource "aws_eks_addon" "this" {
  region = var.region

  cluster_name = var.cluster_name

  addon_name    = var.name
  addon_version = var.addon_version

  configuration_values        = var.configuration
  resolve_conflicts_on_create = var.conflict_resolution_strategy_on_create
  resolve_conflicts_on_update = var.conflict_resolution_strategy_on_update
  preserve                    = var.preserve_on_delete


  ## Auth
  service_account_role_arn = var.service_account_role

  dynamic "pod_identity_association" {
    for_each = var.pod_identity_associations
    iterator = association

    content {
      service_account = association.value.service_account
      role_arn        = association.value.iam_role
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Versions of EKS Addon
###################################################

data "aws_eks_cluster" "this" {
  region = var.region

  name = aws_eks_addon.this.cluster_name
}

data "aws_eks_addon_version" "default" {
  region = var.region

  addon_name         = var.name
  kubernetes_version = data.aws_eks_cluster.this.version
}

data "aws_eks_addon_version" "latest" {
  region = var.region

  addon_name         = var.name
  kubernetes_version = data.aws_eks_cluster.this.version
  most_recent        = true
}
