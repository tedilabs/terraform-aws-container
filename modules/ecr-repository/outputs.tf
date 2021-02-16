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
