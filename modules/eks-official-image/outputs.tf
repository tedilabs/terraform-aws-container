output "id" {
  description = "The ID of the EKS official AMI."
  value       = data.aws_ssm_parameter.this.insecure_value
}

output "parameter" {
  description = "The parameter name of SSM Parameter Store."
  value       = data.aws_ssm_parameter.this.name
}

output "kubernetes_version" {
  description = "The version of Kubernetes."
  value       = var.kubernetes_version
}

output "os" {
  description = "The configuration of OS (Operating System) of the AMI"
  value       = var.os
}

output "arch" {
  description = "The type of the CPU architecture."
  value       = var.arch
}
