output "region" {
  description = "The AWS region this module resources resides in."
  value       = var.region
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = var.cluster_name
}

output "node_access_entries" {
  description = <<EOF
  The list of configurations for EKS access entries for nodes (EC2 instances, Fargate).
  EOF
  value = {
    for name, entry in module.node :
    name => {
      arn                 = entry.arn
      type                = entry.type
      principal           = entry.principal
      kubernetes_username = entry.kubernetes_username
      kubernetes_groups   = entry.kubernetes_groups
      created_at          = entry.created_at
      updated_at          = entry.updated_at
    }
  }
}

output "user_access_entries" {
  description = <<EOF
  The list of configurations for EKS access entries for users (IAM roles, users).
  EOF
  value = {
    for name, entry in module.user :
    name => {
      arn                    = entry.arn
      type                   = entry.type
      principal              = entry.principal
      kubernetes_username    = entry.kubernetes_username
      kubernetes_groups      = entry.kubernetes_groups
      kubernetes_permissions = entry.kubernetes_permissions
      created_at             = entry.created_at
      updated_at             = entry.updated_at
    }
  }
}

output "resource_group" {
  description = "The resource group created to manage resources in this module."
  value = merge(
    {
      enabled = var.resource_group.enabled && var.module_tags_enabled
    },
    (var.resource_group.enabled && var.module_tags_enabled
      ? {
        arn  = module.resource_group[0].arn
        name = module.resource_group[0].name
      }
      : {}
    )
  )
}
