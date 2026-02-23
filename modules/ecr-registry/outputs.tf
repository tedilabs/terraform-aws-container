output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_ecr_account_setting.registry_policy_scope.region
}

output "name" {
  description = "The name of the registry."
  value       = local.metadata.name
}

output "id" {
  description = "The ID of the registry."
  value       = aws_ecr_registry_scanning_configuration.this.registry_id
}

output "policy_version" {
  description = "The policy version of ECR registry."
  value       = aws_ecr_account_setting.registry_policy_scope.value
}

output "policy" {
  description = "The registry policy."
  value       = one(aws_ecr_registry_policy.this[*].policy)
}

output "pull_time_update" {
  description = "The configuration for pull time update in ECR registry."
  value = {
    excluded_principals = values(aws_ecr_pull_time_update_exclusion.this)[*].principal_arn
  }
}

output "blob_mounting" {
  description = "The configuration for blob mounting in ECR registry."
  value = {
    enabled = aws_ecr_account_setting.blob_mounting.value == "ENABLED"
  }
}

output "replication_policies" {
  description = "A list of replication policies for ECR Registry."
  value       = var.replication_policies
}

output "replication_rules" {
  description = "A list of replication rules for ECR Registry."
  value       = var.replication_rules
}

output "pull_through_cache_policies" {
  description = "A list of Pull Through Cache policies for ECR Registry."
  value       = var.pull_through_cache_policies
}

output "pull_through_cache_rules" {
  description = "A list of Pull Through Cache Rules for ECR registry."
  value = [
    for rule in aws_ecr_pull_through_cache_rule.this :
    {
      upstream_url    = rule.upstream_registry_url
      upstream_prefix = rule.upstream_repository_prefix
      namespace       = rule.ecr_repository_prefix

      credential = {
        secretsmanager_secret = rule.credential_arn
        iam_role              = rule.custom_role_arn
      }
    }
  ]
}

output "scanning_type" {
  description = "The scanning type to set for the registry."
  value       = aws_ecr_registry_scanning_configuration.this.scan_type
}

output "scanning_basic_version" {
  description = "The version of basic scanning for the registry."
  value       = aws_ecr_account_setting.basic_scan_type_version.value
}

output "scanning_rules" {
  description = "A list of scanning rules to determine which repository filters are used and at what frequency scanning will occur."
  value       = var.scanning_rules
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
#     pull_through_cache_rules = aws_ecr_pull_through_cache_rule.this
#     replication_rules        = aws_ecr_replication_configuration.this
#     scanning_rules           = aws_ecr_registry_scanning_configuration.this
#   }
# }
