###################################################
# EKS Control Plane
###################################################

locals {
  cluster_timeouts = merge(
    {
      create = "30m",
      update = "60m",
      delete = "15m",
    },
    var.timeouts
  )
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = module.role__control_plane.arn

  enabled_cluster_log_types = var.log_types

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [module.security_group__control_plane.id]

    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.endpoint_public_access_cidrs
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_cidr
  }

  dynamic "encryption_config" {
    for_each = var.encryption_enabled ? ["go"] : []

    content {
      provider {
        key_arn = var.encryption_kms_key
      }
      resources = var.encryption_resources
    }
  }

  tags = merge(
    {
      "Name" = var.cluster_name
    },
    var.tags,
  )

  timeouts {
    create = local.cluster_timeouts.create
    update = local.cluster_timeouts.update
    delete = local.cluster_timeouts.delete
  }

  depends_on = [
    module.role__control_plane,
    aws_cloudwatch_log_group.this,
  ]
}
