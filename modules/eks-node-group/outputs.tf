output "name" {
  description = "The name of the node group."
  value       = var.name
}

output "min_size" {
  description = "The minimum number of instances in the EKS cluster node group."
  value       = aws_autoscaling_group.this.min_size
}

output "max_size" {
  description = "The maximum number of instances in the EKS cluster node group."
  value       = aws_autoscaling_group.this.max_size
}

output "desired_size" {
  description = "The number of instances in the EKS cluster node group."
  value       = aws_autoscaling_group.this.desired_capacity
}

output "instance_ami" {
  description = "The AMI of the EKS cluster node group."
  value       = aws_launch_template.this.image_id
}

output "instance_type" {
  description = "The instance type of the EKS cluster node group."
  value       = aws_launch_template.this.instance_type
}

output "instance_ssh_key" {
  description = "The name of the SSH Key of the EKS cluster node group."
  value       = aws_launch_template.this.key_name
}

output "instance_profile" {
  description = "The name of the IAM instance profile which is attached to instances of the EKS cluster node group."
  value       = var.instance_profile
}

output "default_security_group" {
  description = "The default security group ID of the EKS node group."
  value       = one(module.security_group[*].id)
}

output "security_groups" {
  description = "A set of security group IDs which is assigned to the load balancer."
  value       = aws_launch_template.this.network_interfaces[0].security_groups
}


###################################################
# EKS
###################################################
output "asg_id" {
  description = "The ID of ASG(Auto-Scaling Group)."
  value       = aws_autoscaling_group.this.id
}

output "asg_arn" {
  description = "The ARN of ASG(Auto-Scaling Group)."
  value       = aws_autoscaling_group.this.arn
}

output "asg_name" {
  description = "The name of ASG(Auto-Scaling Group)."
  value       = aws_autoscaling_group.this.name
}
