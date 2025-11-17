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

# INFO: EKS Auto-mode Only
# - `compute_config`
# - `kubernetes_network_config[].elastic_load_balancing.enabled`
# - `storage_config`
resource "aws_eks_cluster" "this" {
  region = var.region

  name                          = var.name
  deletion_protection           = var.deletion_protection_enabled
  bootstrap_self_managed_addons = var.bootstrap_self_managed_addons

  role_arn = (var.default_cluster_role.enabled
    ? module.role[0].arn
    : var.cluster_role
  )

  enabled_cluster_log_types = var.logging.enabled ? var.logging.log_types : []

  zonal_shift_config {
    enabled = var.arc_zonal_shift.enabled
  }

  ## Versioning
  version              = var.kubernetes_version
  force_update_version = var.upgrade_policy.force_upgrade

  upgrade_policy {
    support_type = var.upgrade_policy.support_type
  }


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

      control_plane_instance_type = outpost_config.value.control_plane.instance_type

      dynamic "control_plane_placement" {
        for_each = outpost_config.value.control.plane_placement_group != null ? [outpost_config.value.control_plane.placement_group] : []

        content {
          group_name = control_plane_placement.value
        }
      }
    }
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.kubernetes_network_config.service_ipv4_cidr
    ip_family         = local.ip_family[var.kubernetes_network_config.ip_family]

    dynamic "elastic_load_balancing" {
      for_each = var.auto_mode.network.elastic_load_balancing.enabled ? [var.auto_mode.network.elastic_load_balancing] : []

      content {
        enabled = elastic_load_balancing.value.enabled
      }
    }
  }

  dynamic "remote_network_config" {
    for_each = (length(var.remote_network_config.node_ipv4_cidrs) > 0 || length(var.remote_network_config.pod_ipv4_cidrs) > 0
      ? [var.remote_network_config]
      : []
    )

    content {
      dynamic "remote_node_networks" {
        for_each = length(remote_network_config.value.node_ipv4_cidrs) > 0 ? ["go"] : []

        content {
          cidrs = remote_network_config.value.node_ipv4_cidrs
        }
      }
      dynamic "remote_pod_networks" {
        for_each = length(remote_network_config.value.pod_ipv4_cidrs) > 0 ? ["go"] : []

        content {
          cidrs = remote_network_config.value.pod_ipv4_cidrs
        }
      }
    }
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


  ## Auto-mode Only
  dynamic "compute_config" {
    for_each = var.auto_mode.compute.enabled ? [var.auto_mode.compute] : []

    content {
      enabled    = compute_config.value.enabled
      node_pools = compute_config.value.builtin_node_pools
      node_role_arn = (compute_config.value.enabled
        ? (compute_config.value.node_role != null
          ? compute_config.value.node_role
          : one(module.role__node[*].arn)
        ) : null
      )
    }
  }

  dynamic "storage_config" {
    for_each = var.auto_mode.storage.block_storage.enabled ? [var.auto_mode.storage] : []

    content {
      dynamic "block_storage" {
        for_each = storage_config.value.block_storage.enabled ? [storage_config.value.block_storage] : []

        content {
          enabled = block_storage.value.enabled
        }
      }
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
