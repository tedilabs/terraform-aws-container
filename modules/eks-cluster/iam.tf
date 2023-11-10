###################################################
# IAM Role for Control Plane
###################################################

module "role" {
  count = var.default_cluster_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.28.0"

  name = coalesce(
    var.default_cluster_role.name,
    "eks-${local.metadata.name}-cluster",
  )
  path        = var.default_cluster_role.path
  description = var.default_cluster_role.description

  trusted_service_policies = [
    {
      services = ["eks.amazonaws.com"]
    }
  ]

  policies = concat(
    ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"],
    var.default_cluster_role.policies,
  )
  inline_policies = var.default_cluster_role.inline_policies

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
  count = var.default_node_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.28.0"

  name = coalesce(
    var.default_node_role.name,
    "eks-${local.metadata.name}-node",
  )
  path        = var.default_node_role.path
  description = var.default_node_role.description

  trusted_service_policies = [
    {
      services = ["ec2.amazonaws.com"]
    }
  ]

  policies = concat(
    [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      # TODO: https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    ],
    var.default_node_role.policies,
  )
  inline_policies = var.default_node_role.inline_policies

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
