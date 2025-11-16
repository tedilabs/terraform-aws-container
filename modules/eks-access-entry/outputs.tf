output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_eks_access_entry.this.region
}

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
  value = (var.type == "STANDARD"
    ? [
      for assoc in aws_eks_access_policy_association.this :
      {
        policy     = assoc.policy_arn
        scope      = upper(assoc.access_scope[0].type)
        namespaces = assoc.access_scope[0].namespaces

        associated_at = assoc.associated_at
        updated_at    = assoc.modified_at
      }
    ]
    : []
  )
}

output "created_at" {
  description = "Date and time in RFC3339 format that the EKS access entry was created."
  value       = aws_eks_access_entry.this.created_at
}

output "updated_at" {
  description = "Date and time in RFC3339 format that the EKS access entry was updated."
  value       = aws_eks_access_entry.this.modified_at
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
#     entry = {
#       for k, v in aws_eks_access_entry.this :
#       k => v
#       if !contains(["user_name", "kubernetes_groups", "created_at", "modified_at", "region", "access_entry_arn", "type", "principal_arn", "timeouts", "tags", "tags_all", "cluster_name", "id"], k)
#     }
#     policy_associations = {
#       for name, assoc in aws_eks_access_policy_association.this :
#       name => {
#         for k, v in assoc :
#         k => v
#         if !contains(["region", "timeouts", "cluster_name", "id", "principal_arn", "policy_arn", "access_scope", "associated_at", "modified_at"], k)
#       }
#     }
#   }
# }
