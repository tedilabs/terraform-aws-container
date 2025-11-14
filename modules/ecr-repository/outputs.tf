output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_ecr_repository.this.region
}

output "name" {
  description = "The name of the repository."
  value       = var.name
}

output "arn" {
  description = "The ARN of the repository."
  value       = aws_ecr_repository.this.arn
}

output "registry_id" {
  description = "The registry ID where the repository was created."
  value       = aws_ecr_repository.this.registry_id
}

output "url" {
  description = "The URL of the repository (in the form aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName)."
  value       = aws_ecr_repository.this.repository_url
}

output "image_tag_immutable_enabled" {
  description = "Whether to enable tag immutability to prevent image tags from being overwritten."
  value       = aws_ecr_repository.this.image_tag_mutability == "IMMUTABLE"
}

output "image_scan_on_push_enabled" {
  description = "Whether to scan image on push."
  value       = aws_ecr_repository.this.image_scanning_configuration[0].scan_on_push
}

output "lifecycle_rules" {
  description = "The lifecycle rules for the repository."
  value       = var.lifecycle_rules
}

output "encryption" {
  description = "The encryption configuration of the repository."
  value = {
    type    = aws_ecr_repository.this.encryption_configuration[0].encryption_type
    kms_key = aws_ecr_repository.this.encryption_configuration[0].kms_key
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
