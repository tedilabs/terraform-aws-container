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
