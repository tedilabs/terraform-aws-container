output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_addon.this.cluster_name
}

output "name" {
  description = "The name of the EKS add-on."
  value       = aws_eks_addon.this.addon_name
}

output "addon_version" {
  description = "The version of the EKS add-on."
  value       = aws_eks_addon.this.addon_version
}

output "id" {
  description = "The ID of the EKS add-on."
  value       = aws_eks_addon.this.id
}

output "arn" {
  description = "The ARN of the EKS add-on."
  value       = aws_eks_addon.this.arn
}

output "created_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was created."
  value       = aws_eks_addon.this.created_at
}

output "updated_at" {
  description = "Date and time in RFC3339 format that the EKS add-on was updated."
  value       = aws_eks_addon.this.modified_at
}

output "service_account_role" {
  description = "The ARN (Amazon Resource Name) of the IAM Role to bind to the add-on's service account"
  value       = aws_eks_addon.this.service_account_role_arn
}

output "conflict_resolution_strategy_on_create" {
  description = "How to resolve field value conflicts when migrating a self-managed add-on to an EKS add-on."
  value       = aws_eks_addon.this.resolve_conflicts_on_create
}

output "conflict_resolution_strategy_on_update" {
  description = "How to resolve field value conflicts for an EKS add-on if you've changed a value from the EKS default value."
  value       = aws_eks_addon.this.resolve_conflicts_on_update
}
