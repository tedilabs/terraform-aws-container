output "name" {
  description = "The name of the registry."
  value       = local.metadata.name
}

output "id" {
  description = "The ID of the registry."
  value       = try(aws_ecr_replication_configuration.this[*].registry_id[0], local.metadata.name)
}

output "policy" {
  description = "The registry policy."
  value       = one(aws_ecr_registry_policy.this[*].policy)
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
  value       = var.pull_through_cache_rules
}

output "scanning_type" {
  description = "The scanning type to set for the registry."
  value       = aws_ecr_registry_scanning_configuration.this.scan_type
}

output "scanning_rules" {
  description = "A list of scanning rules to determine which repository filters are used and at what frequency scanning will occur."
  value       = var.scanning_rules
}

# output "debug" {
#   value = {
#     pull_through_cache_rules = aws_ecr_pull_through_cache_rule.this
#     replication_rules        = aws_ecr_replication_configuration.this
#     scanning_rules           = aws_ecr_registry_scanning_configuration.this
#   }
# }
