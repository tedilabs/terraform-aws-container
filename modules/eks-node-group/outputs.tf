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
