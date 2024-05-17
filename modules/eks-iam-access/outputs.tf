output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = var.cluster_name
}

output "node_access_entries" {
  description = <<EOF
  The list of configurations for EKS access entries for nodes (EC2 instances, Fargate).
  EOF
  value = {
    for name, entry in aws_eks_access_entry.node :
    name => {
      arn        = entry.access_entry_arn
      type       = entry.type
      principal  = entry.principal_arn
      username   = entry.user_name
      groups     = entry.kubernetes_groups
      created_at = entry.created_at
      updated_at = entry.modified_at
    }
  }
}

output "user_access_entries" {
  description = <<EOF
  The list of configurations for EKS access entries for users (IAM roles, users).
  EOF
  value = {
    for name, entry in aws_eks_access_entry.user :
    name => {
      arn        = entry.access_entry_arn
      type       = entry.type
      principal  = entry.principal_arn
      username   = entry.user_name
      groups     = entry.kubernetes_groups
      created_at = entry.created_at
      updated_at = entry.modified_at
    }
  }
}
