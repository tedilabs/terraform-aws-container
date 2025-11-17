data "aws_default_tags" "this" {}

data "aws_subnet" "selected" {
  region = var.region

  id = var.subnets[0]
}

locals {
  vpc_id = data.aws_subnet.selected.vpc_id
}


###################################################
# Cluster Security Group
###################################################

# INFO: This should not affect the name of the cluster primary security group
resource "aws_ec2_tag" "cluster_security_group" {
  for_each = {
    for k, v in merge(
      data.aws_default_tags.this.tags,
      local.module_tags,
      var.tags
    ) :
    k => v
    if !contains(["Name", "kubernetes.io/cluster/${local.metadata.name}"], k)
  }

  region = var.region

  resource_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  key         = each.key
  value       = each.value
}

resource "aws_vpc_security_group_ingress_rule" "node" {
  region = var.region

  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description       = "Allow nodes to communicate to the cluster security group(for fargate pods)."

  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1

  referenced_security_group_id = module.security_group__node.id

  tags = merge(
    {
      "Name" = "node"
    },
    local.module_tags,
    var.tags,
  )
}

resource "aws_vpc_security_group_ingress_rule" "pod" {
  region = var.region

  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  description       = "Allow pods to communicate to the cluster security group(for fargate pods)."

  ip_protocol = "-1"
  from_port   = -1
  to_port     = -1

  referenced_security_group_id = module.security_group__pod.id

  tags = merge(
    {
      "Name" = "pod"
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Security Group for Control Plane
###################################################

module "security_group__control_plane" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "~> 1.1.0"

  region = var.region

  name        = "eks-${local.metadata.name}-control-plane"
  description = "Security Group for EKS Control Plane."
  vpc_id      = local.vpc_id

  ingress_rules = concat(
    [
      {
        id          = "cluster-api/nodes"
        description = "Allow nodes to communicate with the cluster API server."
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443

        security_groups = [module.security_group__node.id]
      },
      {
        id          = "cluster-api/pods"
        description = "Allow pods to communicate with the cluster API server."
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443

        security_groups = [module.security_group__pod.id]
      }
    ],
    var.endpoint_access.private_access_enabled && length(var.endpoint_access.private_access_cidrs) > 0 ? [
      {
        id          = "cluster-api/cidrs"
        description = "Allow CIDRs to communicate with the cluster API server."
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443

        ipv4_cidrs = var.endpoint_access.private_access_cidrs
      }
    ] : [],
    [
      for idx, source_security_group_id in var.endpoint_access.private_access_security_groups : {
        id          = "cluster-api/security-groups/${idx}"
        description = "Allow source security groups to communicate with the cluster API server."
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443

        security_groups = [source_security_group_id]
      }
      if var.endpoint_access.private_access_enabled
    ]
  )
  egress_rules = [
    {
      id          = "ephemeral/nodes"
      description = "Allow control plane to ephemrally communicate with nodes."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      security_groups = [module.security_group__node.id]
    },
    {
      id          = "ephemeral/pods"
      description = "Allow control plane to ephemrally communicate with pods."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      security_groups = [module.security_group__pod.id]
    },
  ]

  revoke_rules_on_delete = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    {
      "kubernetes.io/cluster/${local.metadata.name}" = "owned"
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Security Group for Nodes
###################################################

module "security_group__node" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "~> 1.1.0"

  region = var.region

  name        = "eks-${local.metadata.name}-node"
  description = "Security Group for all nodes in the EKS cluster."
  vpc_id      = local.vpc_id

  ingress_rules = [
    {
      id          = "all/self"
      description = "Allow nodes to communicate each others."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      self = true
    },
    {
      id          = "all/cluster"
      description = "Allow nodes to communicate from the cluster security group(for fargate pods)."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      security_groups = [aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
    },
    {
      id          = "ephemeral/control-plane"
      description = "Allow nodes to receive communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      security_groups = [module.security_group__control_plane.id]
    },
    {
      id          = "kubelet/control-plane"
      description = "Allow nodes to receive communication from the cluster control plane for kubelet."
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250

      security_groups = [module.security_group__control_plane.id]
    },
    {
      id          = "kubelet/pods"
      description = "Allow nodes to receive communication from the pods for kubelet."
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250

      security_groups = [module.security_group__pod.id]
    },
    {
      id          = "node-exporter/pods"
      description = "Allow nodes to receive communication from the pods for node-exporter."
      protocol    = "tcp"
      from_port   = 9100
      to_port     = 9100

      security_groups = [module.security_group__pod.id]
    },
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow nodes egress access to the Internet."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      ipv4_cidrs = ["0.0.0.0/0"]
      ipv6_cidrs = ["::/0"]
    },
    {
      id          = "all/cluster"
      description = "Allow nodes egress access to the cluster security group(for fargate pods)."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      security_groups = [aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
    },
  ]

  revoke_rules_on_delete = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    {
      "kubernetes.io/cluster/${local.metadata.name}" = "owned"
    },
    local.module_tags,
    var.tags,
  )
}


###################################################
# Security Group for Pods
###################################################

module "security_group__pod" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "~> 1.1.0"

  region = var.region

  name        = "eks-${local.metadata.name}-pod"
  description = "Security Group for all pods in the EKS cluster."
  vpc_id      = local.vpc_id

  ingress_rules = [
    {
      id          = "all/self"
      description = "Allow pods to communicate each others."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      self = true
    },
    {
      id          = "all/nodes"
      description = "Allow pods to communicate from the nodes."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      security_groups = [module.security_group__node.id]
    },
    {
      id          = "all/cluster"
      description = "Allow pods to communicate from the cluster security group(for fargate pods)."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      security_groups = [aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
    },
    {
      id          = "metrics-server/control-plane"
      description = "Allow pods to receive metrics-server communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443

      security_groups = [module.security_group__control_plane.id]
    },
    {
      id          = "ephemeral/control-plane"
      description = "Allow pods to receive communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      security_groups = [module.security_group__control_plane.id]
    },
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow pods to communicate to the Internet."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      ipv4_cidrs = ["0.0.0.0/0"]
      ipv6_cidrs = ["::/0"]
    },
  ]

  revoke_rules_on_delete = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    {
      "kubernetes.io/cluster/${local.metadata.name}" = "owned"
    },
    local.module_tags,
    var.tags,
  )
}
