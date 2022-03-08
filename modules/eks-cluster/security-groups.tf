data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

locals {
  vpc_id = data.aws_subnet.selected.vpc_id
}


###################################################
# Cluster Security Group Rules
###################################################

resource "aws_security_group_rule" "node" {
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  type              = "ingress"
  description       = "Allow nodes to communicate to the cluster security group(for fargate pods)."

  protocol  = "-1"
  from_port = 0
  to_port   = 0

  source_security_group_id = module.security_group__node.id
}

resource "aws_security_group_rule" "pod" {
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  type              = "ingress"
  description       = "Allow pods to communicate to the cluster security group(for fargate pods)."

  protocol  = "-1"
  from_port = 0
  to_port   = 0

  source_security_group_id = module.security_group__pod.id
}


###################################################
# Security Group for Control Plane
###################################################

module "security_group__control_plane" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "0.24.0"

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

        source_security_group_id = module.security_group__node.id
      },
      {
        id          = "cluster-api/pods"
        description = "Allow pods to communicate with the cluster API server."
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443

        source_security_group_id = module.security_group__pod.id
      }
    ],
    var.endpoint_private_access && length(var.endpoint_private_access_cidrs) > 0 ? [
      {
        id          = "cluster-api/cidrs"
        description = "Allow CIDRs to communicate with the cluster API server."
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443

        cidr_blocks = var.endpoint_private_access_cidrs
      }
    ] : [],
    [
      for idx, source_security_group_id in var.endpoint_private_access_source_security_group_ids : {
        id          = "cluster-api/security-groups/${idx}"
        description = "Allow source security groups to communicate with the cluster API server."
        protocol    = "tcp"
        from_port   = 443
        to_port     = 443

        source_security_group_id = source_security_group_id
      }
      if var.endpoint_private_access
    ]
  )
  egress_rules = [
    {
      id          = "ephemeral/nodes"
      description = "Allow control plane to ephemrally communicate with nodes."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      source_security_group_id = module.security_group__node.id
    },
    {
      id          = "ephemeral/pods"
      description = "Allow control plane to ephemrally communicate with pods."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      source_security_group_id = module.security_group__pod.id
    },
  ]

  resource_group_enabled = false
  module_tags_enabled    = false

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
  version = "0.24.0"

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

      source_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
    },
    {
      id          = "ephemeral/control-plane"
      description = "Allow nodes to receive communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      source_security_group_id = module.security_group__control_plane.id
    },
    {
      id          = "kubelet/control-plane"
      description = "Allow nodes to receive communication from the cluster control plane for kubelet."
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250

      source_security_group_id = module.security_group__control_plane.id
    },
    {
      id          = "kubelet/pods"
      description = "Allow nodes to receive communication from the pods for kubelet."
      protocol    = "tcp"
      from_port   = 10250
      to_port     = 10250

      source_security_group_id = module.security_group__pod.id
    },
    {
      id          = "node-exporter/pods"
      description = "Allow nodes to receive communication from the pods for node-exporter."
      protocol    = "tcp"
      from_port   = 9100
      to_port     = 9100

      source_security_group_id = module.security_group__pod.id
    },
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow nodes egress access to the Internet."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      id          = "all/cluster"
      description = "Allow nodes egress access to the cluster security group(for fargate pods)."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      source_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
    },
  ]

  resource_group_enabled = false
  module_tags_enabled    = false

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
  version = "0.24.0"

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

      source_security_group_id = module.security_group__node.id
    },
    {
      id          = "all/cluster"
      description = "Allow pods to communicate from the cluster security group(for fargate pods)."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      source_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
    },
    {
      id          = "metrics-server/control-plane"
      description = "Allow pods to receive metrics-server communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443

      source_security_group_id = module.security_group__control_plane.id
    },
    {
      id          = "ephemeral/control-plane"
      description = "Allow pods to receive communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      source_security_group_id = module.security_group__control_plane.id
    },
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow pods to communicate to the Internet."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
  ]

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    {
      "kubernetes.io/cluster/${local.metadata.name}" = "owned"
    },
    local.module_tags,
    var.tags,
  )
}
