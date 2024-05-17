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

locals {
  ip_family = {
    "IPv4" = "ipv4"
    "IPv6" = "ipv6"
  }
}


###################################################
# EKS Control Plane
###################################################

resource "aws_eks_cluster" "this" {
  name    = var.name
  version = var.kubernetes_version
  role_arn = (var.default_cluster_role.enabled
    ? module.role[0].arn
    : var.cluster_role
  )

  enabled_cluster_log_types = var.log_types


  ## Network
  vpc_config {
    subnet_ids = var.subnets
    security_group_ids = concat(
      [module.security_group__control_plane.id],
      var.additional_security_groups,
    )

    endpoint_private_access = var.endpoint_access.private_access_enabled
    endpoint_public_access  = var.endpoint_access.public_access_enabled
    public_access_cidrs     = var.endpoint_access.public_access_cidrs
  }

  dynamic "outpost_config" {
    for_each = var.outpost_config != null ? [var.outpost_config] : []

    content {
      outpost_arns = outpost_config.value.outposts

      control_plane_instance_type = outpost_config.value.control_plane_instance_type

      dynamic "control_plane_placement" {
        for_each = outpost_config.value.control_plane_placement_group != null ? [outpost_config.value.control_plane_placement_group] : []

        content {
          group_name = control_plane_placement.value
        }
      }
    }
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.kubernetes_network_config.service_ipv4_cidr
    ip_family         = local.ip_family[var.kubernetes_network_config.ip_family]
  }


  ## Access Control
  access_config {
    authentication_mode                         = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_access
  }


  ## Encryption
  dynamic "encryption_config" {
    for_each = var.secrets_encryption.enabled ? [var.secrets_encryption] : []

    content {
      provider {
        key_arn = encryption_config.value.kms_key
      }
      resources = ["secrets"]
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

  depends_on = [
    module.role,
  ]
}
