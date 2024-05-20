output "name" {
  description = "The name of the EKS access entry."
  value       = var.name
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = var.cluster_name
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the EKS access entry."
  value       = aws_eks_access_entry.this.access_entry_arn
}

output "type" {
  description = "The type of the access entry."
  value       = aws_eks_access_entry.this.type
}

output "principal" {
  description = "The ARN of one, and only one, existing IAM principal to grant access to Kubernetes objects on the cluster."
  value       = aws_eks_access_entry.this.principal_arn
}

output "kubernetes_username" {
  description = "The authenticated username in Kubernetes cluster."
  value       = aws_eks_access_entry.this.user_name
}

output "kubernetes_groups" {
  description = "The authenticated groups in Kubernetes cluster."
  value       = aws_eks_access_entry.this.kubernetes_groups
}

output "kubernetes_permissions" {
  description = "The list of permissions for EKS access entry to the EKS cluster."
  value       = var.kubernetes_permissions
}

output "created_at" {
  description = "Date and time in RFC3339 format that the EKS access entry was created."
  value       = aws_eks_access_entry.this.created_at
}

output "updated_at" {
  description = "Date and time in RFC3339 format that the EKS access entry was updated."
  value       = aws_eks_access_entry.this.modified_at
}
