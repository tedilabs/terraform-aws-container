output "name" {
  description = "The name of the cluster."
  value       = aws_eks_cluster.this.id
}

output "arn" {
  description = "The ARN of the cluster."
  value       = aws_eks_cluster.this.arn
}

output "version" {
  description = "The Kubernetes server version for the cluster."
  value       = aws_eks_cluster.this.version
}

output "platform_version" {
  description = "The platform version for the cluster."
  value       = aws_eks_cluster.this.platform_version
}

output "status" {
  description = "The status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`."
  value       = aws_eks_cluster.this.status
}

output "endpoint" {
  description = "The endpoint for the Kubernetes API server."
  value       = aws_eks_cluster.this.endpoint
}

output "ca_cert" {
  description = "The base64 encoded certificate data required to communicate with your cluster. Add this to the `certificate-authority-data` section of the `kubeconfig` file for your cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "vpc_id" {
  description = "The ID of VPC associated with the cluster."
  value       = aws_eks_cluster.this.vpc_config[0].vpc_id
}

output "subnet_ids" {
  description = "Subnets which the ENIs of Kubernetes control plane are located in."
  value       = aws_eks_cluster.this.vpc_config[0].subnet_ids
}

output "service_cidr" {
  description = "The CIDR block which is assigned to Kubernetes service IP addresses."
  value       = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr
}

output "security_group_ids" {
  description = "Security groups that were created for the EKS cluster."
  value = {
    cluster       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
    control_plane = module.security_group__control_plane.id
    node          = module.security_group__node.id
    pod           = module.security_group__pod.id
  }
}

output "iam_roles" {
  description = "IAM Roles for the EKS cluster."
  value = {
    control_plane   = module.role__control_plane
    node            = module.role__node
    fargate_profile = module.role__fargate_profile
  }
}

output "oidc_provider_arn" {
  description = "The Amazon Resource Name (ARN) for the OpenID Connect identity provider."
  value       = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  description = "Issuer URL for the OpenID Connect identity provider."
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "oidc_provider_urn" {
  description = "Issuer URN for the OpenID Connect identity provider."
  value       = aws_iam_openid_connect_provider.this.url
}

output "log_group_name" {
  description = "The Name of the log group."
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "The Amazon Resource Name (ARN) specifying the log group."
  value       = aws_cloudwatch_log_group.this.arn
}

output "log_types" {
  description = "A list of the enabled control plane logging."
  value       = aws_eks_cluster.this.enabled_cluster_log_types
}
