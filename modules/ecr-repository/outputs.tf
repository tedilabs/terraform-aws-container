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

output "encryption" {
  description = "The configuration for the encryption of repository."
  value = {
    type    = aws_ecr_repository.this.encryption_configuration[0].encryption_type
    kms_key = aws_ecr_repository.this.encryption_configuration[0].kms_key
  }
}
