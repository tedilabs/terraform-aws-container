output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_eks_addon.this.region
}

output "id" {
  description = "The ID of the EKS add-on."
  value       = aws_eks_addon.this.id
}

output "arn" {
  description = "The ARN of the EKS add-on."
  value       = aws_eks_addon.this.arn
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_addon.this.cluster_name
}

output "name" {
  description = "The name of the EKS add-on."
  value       = aws_eks_addon.this.addon_name
}

output "version" {
  description = "The version of the EKS add-on."
  value       = aws_eks_addon.this.addon_version
}

output "default_version" {
  description = "The default version of the EKS add-on compatible with the EKS cluster version."
  value       = data.aws_eks_addon_version.default.version
}

output "latest_version" {
  description = "The latest version of the EKS add-on compatible with the EKS cluster version."
  value       = data.aws_eks_addon_version.latest.version
}

output "is_latest" {
  description = "Whether the EKS add-on version is the latest available."
  value       = aws_eks_addon.this.addon_version == data.aws_eks_addon_version.latest.version
}

output "configuration" {
  description = "The set of configuration values for the add-on."
  value       = aws_eks_addon.this.configuration_values
}

output "conflict_resolution_strategy_on_create" {
  description = "How to resolve field value conflicts when migrating a self-managed add-on to an EKS add-on."
  value       = aws_eks_addon.this.resolve_conflicts_on_create
}

output "conflict_resolution_strategy_on_update" {
  description = "How to resolve field value conflicts for an EKS add-on if you've changed a value from the EKS default value."
  value       = aws_eks_addon.this.resolve_conflicts_on_update
}

output "service_account_role" {
  description = "The ARN (Amazon Resource Name) of the IAM Role to bind to the add-on's service account"
  value       = aws_eks_addon.this.service_account_role_arn
}

output "pod_identity_associations" {
  description = "The list of pod identity associations for the EKS add-on."
  value = [
    for association in aws_eks_addon.this.pod_identity_association :
    {
      service_account = association.service_account
      role_arn        = association.role_arn
    }
  ]
}

output "created_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was created."
  value       = aws_eks_addon.this.created_at
}

output "updated_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was updated."
  value       = aws_eks_addon.this.modified_at
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

# output "debug" {
#   value = {
#     for k, v in aws_eks_addon.this :
#     k => v
#     if !contains(["id", "arn", "cluster_name", "addon_name", "addon_version", "service_account_role_arn", "resolve_conflicts_on_create", "resolve_conflicts_on_update", "created_at", "modified_at", "tags", "tags_all", "timeouts", "region", "preserve", "configuration_values", "pod_identity_association"], k)
#   }
# }
