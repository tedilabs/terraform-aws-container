###################################################
# EKS
###################################################
output "asg_id" {
  value = aws_autoscaling_group.this.id
}

output "asg_arn" {
  value = aws_autoscaling_group.this.arn
}

output "asg_name" {
  value = aws_autoscaling_group.this.name
}


###################################################
# Resource Group
###################################################

output "resource_group_enabled" {
  description = "Whether Resource Group is enabled."
  value       = var.resource_group_enabled
}

output "resource_group_name" {
  description = "The name of Resource Group."
  value       = try(aws_resourcegroups_group.this.*.name[0], null)
}
