###################################################
# IAM Role for Control Plane
###################################################

module "role__control_plane" {
  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.28.0"

  name        = "eks-${local.metadata.name}-control-plane"
  path        = "/"
  description = "Role for the EKS cluster(${local.metadata.name}) control plane"

  trusted_service_policies = [
    {
      services = ["eks.amazonaws.com"]
    }
  ]

  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  ]

  force_detach_policies  = true
  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# IAM Role for Nodes
###################################################

module "role__node" {
  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.28.0"

  name        = "eks-${local.metadata.name}-node"
  path        = "/"
  description = "Role for the EKS cluster(${local.metadata.name}) nodes"

  trusted_service_policies = [
    {
      services = ["ec2.amazonaws.com"]
    }
  ]

  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    # TODO: https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]

  instance_profile = {
    enabled = true
  }

  force_detach_policies  = true
  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# IAM Role for Fargate Profiles
###################################################

module "role__fargate_profile" {
  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.28.0"

  name        = "eks-${local.metadata.name}-fargate-profile"
  path        = "/"
  description = "Role for the EKS cluster(${local.metadata.name}) Fargate profiles"

  trusted_service_policies = [
    {
      services = ["eks-fargate-pods.amazonaws.com"]
    }
  ]

  policies = ["arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"]

  force_detach_policies  = true
  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
