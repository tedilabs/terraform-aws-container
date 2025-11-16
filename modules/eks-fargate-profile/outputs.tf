output "region" {
  description = "The AWS region this module resources resides in."
  value       = aws_eks_fargate_profile.this.region
}

output "cluster_name" {
  description = "The name of the EKS cluster."
  value       = aws_eks_fargate_profile.this.cluster_name
}

output "name" {
  description = "The name of the Fargate Profile."
  value       = aws_eks_fargate_profile.this.fargate_profile_name
}

output "id" {
  description = "The ID of the Fargate Profile."
  value       = aws_eks_fargate_profile.this.id
}

output "arn" {
  description = "The ARN of the Fargate Profile."
  value       = aws_eks_fargate_profile.this.arn
}

output "status" {
  description = "The status of the EKS Fargate Profile."
  value       = aws_eks_fargate_profile.this.status
}

output "subnets" {
  description = "The IDs of subnets in which to launch pods."
  value       = aws_eks_fargate_profile.this.subnet_ids
}

output "pod_execution_role" {
  description = "The ARN (Amazon Resource Name) of the IAM Role that provides permissions for the EKS Fargate Profile."
  value       = aws_eks_fargate_profile.this.pod_execution_role_arn
}

output "selectors" {
  description = "A list of selectors to match for pods to use this Fargate profile."
  value       = aws_eks_fargate_profile.this.selector
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
