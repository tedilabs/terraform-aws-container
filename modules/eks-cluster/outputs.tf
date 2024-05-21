output "name" {
  description = "The name of the cluster."
  value       = aws_eks_cluster.this.name
}

output "id" {
  description = "The ID of the cluster."
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

output "vpc_id" {
  description = "The ID of VPC associated with the cluster."
  value       = aws_eks_cluster.this.vpc_config[0].vpc_id
}

output "subnets" {
  description = "The IDs of subnets which the ENIs of Kubernetes control plane are located in."
  value       = aws_eks_cluster.this.vpc_config[0].subnet_ids
}

output "cluster_security_group" {
  description = "The security group that was created by EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "additional_security_groups" {
  description = "The list of additional security groups for the EKS control plane."
  value       = aws_eks_cluster.this.vpc_config[0].security_group_ids
}

output "security_group_ids" {
  description = "Security groups that were created for the EKS cluster."
  value = {
    control_plane = module.security_group__control_plane.id
    node          = module.security_group__node.id
    pod           = module.security_group__pod.id
  }
}

output "endpoint" {
  description = "The endpoint for the Kubernetes API server."
  value       = aws_eks_cluster.this.endpoint
}

output "endpoint_access" {
  description = "The configuration for the endpoint access to the Kubernetes API server endpoint."
  value = {
    private_access_enabled = aws_eks_cluster.this.vpc_config[0].endpoint_private_access
    public_access_enabled  = aws_eks_cluster.this.vpc_config[0].endpoint_public_access
    public_access_cidrs    = aws_eks_cluster.this.vpc_config[0].public_access_cidrs
  }
}

output "outpost_config" {
  description = <<EOF
  The configurations of the outpost for the EKS cluster.
    `outposts` - The list of the Outposts ARNs.
    `control_plane_instance_type` - The EC2 instance type of the local EKS control plane node on Outposts.
    `control_plane_placement_group` - The name of the placement group for the EKS control plane node on Outposts.
  EOF
  value = (var.outpost_config != null
    ? {
      outposts                      = aws_eks_cluster.this.outpost_config[0].outpost_arns
      cluster_id                    = aws_eks_cluster.this.cluster_id
      control_plane_instance_type   = aws_eks_cluster.this.outpost_config[0].control_plane_instance_type
      control_plane_placement_group = one(aws_eks_cluster.this.outpost_config[0].control_plane_placement[*].group_name)
    }
    : null
  )
}

output "kubernetes_network_config" {
  description = <<EOF
  The configurations of Kubernetes network.
    `service_ipv4_cidr` - The IPv4 CIDR block which is assigned to Kubernetes service IP addresses.
    `service_ipv6_cidr` - The IPv6 CIDR block that Kubernetes pod and service IP addresses are assigned from if you specified `IPV6` for `ip_family` when you created the cluster. Kubernetes assigns service addresses from the unique local address range (fc00::/7) because you can't specify a custom IPv6 CIDR block when you create the cluster.
    `ip_family` - The IP family used to assign Kubernetes pod and service addresses.
  EOF
  value = {
    service_ipv4_cidr = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr
    service_ipv6_cidr = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv6_cidr
    ip_family         = var.kubernetes_network_config.ip_family
  }
}

output "authentication_mode" {
  description = "The authentication mode for the cluster."
  value       = aws_eks_cluster.this.access_config[0].authentication_mode
}

output "ca_cert" {
  description = "The base64 encoded certificate data required to communicate with your cluster. Add this to the `certificate-authority-data` section of the `kubeconfig` file for your cluster."
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "secrets_encryption" {
  description = <<EOF
  The configurations of the encryption of Kubernetes secrets.
  EOF
  value = {
    enabled = var.secrets_encryption.enabled
    kms_key = one(aws_eks_cluster.this.encryption_config[*].provider[0].key_arn)
  }
}

output "cluster_role" {
  description = "The IAM Role for the EKS cluster."
  value       = aws_eks_cluster.this.role_arn
}

output "default_cluster_role" {
  description = "The default IAM Role for the EKS cluster."
  value       = one(module.role)
}

output "default_node_role" {
  description = "The default IAM Role for the EKS node."
  value       = one(module.role__node)
}

output "irsa_oidc_provider" {
  description = <<EOF
  The configurations of the OIDC provider for IRSA (IAM Roles for Service Accounts).
    `arn` - The ARN assigned by AWS for this provider.
    `url` - The URL of the identity provider.
    `urn` - The URN of the identity provider.
    `audiences` - A list of audiences (also known as client IDs) for the IAM OIDC provider.
  EOF
  value = {
    arn       = module.oidc_provider.arn
    url       = aws_eks_cluster.this.identity[0].oidc[0].issuer
    urn       = module.oidc_provider.urn
    audiences = module.oidc_provider.audiences
  }
}

output "logging" {
  description = "The configurations of the control plane logging."
  value = {
    log_types = aws_eks_cluster.this.enabled_cluster_log_types
    cloudwatch_log_group = {
      arn  = data.aws_cloudwatch_log_group.this.arn
      name = data.aws_cloudwatch_log_group.this.name
    }
  }
}

output "oidc_identity_providers" {
  description = "A map of all associated OIDC Identity Providers to the cluster."
  value = {
    for name, provider in aws_eks_identity_provider_config.this :
    name => {
      arn        = provider.arn
      status     = provider.status
      name       = provider.oidc[0].identity_provider_config_name
      issuer_url = provider.oidc[0].issuer_url
      client_id  = provider.oidc[0].client_id

      required_claims = provider.oidc[0].required_claims
      username_claim  = provider.oidc[0].username_claim
      username_prefix = provider.oidc[0].username_prefix
      groups_claim    = provider.oidc[0].groups_claim
      groups_prefix   = provider.oidc[0].groups_prefix
    }
  }
}

output "created_at" {
  description = "The Unix epoch timestamp in seconds for when the cluster was created."
  value       = aws_eks_cluster.this.created_at
}

# output "debug" {
#   value = {
#     for k, v in aws_eks_cluster.this :
#     k => v
#     if !contains(["arn", "access_config", "certificate_authority", "tags", "tags_all", "created_at", "role_arn", "name", "status", "version", "timeouts", "platform_version", "kubernetes_network_config", "id", "endpoint", "encryption_config", "outpost_config", "identity", "vpc_config", "enabled_cluster_log_types", "cluster_id"], k)
#   }
# }
