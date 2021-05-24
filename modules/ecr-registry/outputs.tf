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
  value       = try(aws_ecr_registry_policy.this.*.policy[0], null)
}

output "replication_destinations" {
  description = "A list of destinations for ECR registry replication."
  value       = var.replication_destinations
}
