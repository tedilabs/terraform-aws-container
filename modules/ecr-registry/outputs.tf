output "name" {
  description = "The name of the registry."
  value       = local.metadata.name
}

output "id" {
  description = "The ID of the registry."
  value       = try(aws_ecr_replication_configuration.this.*.registry_id[0], local.metadata.name)
}

output "policy" {
  description = "The registry policy."
  value       = one(aws_ecr_registry_policy.this.*.policy)
}

output "replication_destinations" {
  description = "A list of destinations for ECR registry replication."
  value       = var.replication_destinations
}

output "pull_through_cache_rules" {
  description = "A list of Pull Through Cache Rules for ECR registry."
  value = [
    for id, rule in aws_ecr_pull_through_cache_rule.this : {
      id           = id
      namespace    = rule.ecr_repository_prefix
      upstream_url = rule.upstream_registry_url
    }
  ]
}

output "scanning_type" {
  description = "The scanning type for the registry."
  value       = aws_ecr_registry_scanning_configuration.this.scan_type
}

output "scanning_on_push_filters" {
  description = "A list of repository filter to scan on push."
  value       = var.scanning_on_push_filters
}

output "scanning_continuous_filters" {
  description = "A list of repository filter to scan continuous."
  value       = var.scanning_continuous_filters
}
