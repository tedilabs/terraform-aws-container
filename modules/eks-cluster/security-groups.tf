data "aws_subnet" "selected" {
  id = var.subnet_ids[0]
}

locals {
  vpc_id = data.aws_subnet.selected.vpc_id
}


###################################################
# Security Group for Control Plane
###################################################

module "security_group__control_plane" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "0.12.0"

  name        = "eks-${var.cluster_name}-control-plane"
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
      description = "Allow cluster egress access to nodes."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      source_security_group_id = module.security_group__node.id
    },
  ]

  tags = merge(
    {
      "Name"                                      = "eks-${var.cluster_name}-master"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    var.tags,
  )
}


###################################################
# Security Group for Nodes
###################################################

module "security_group__node" {
  source  = "tedilabs/network/aws//modules/security-group"
  version = "0.12.0"

  name        = "eks-${var.cluster_name}-node"
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
      id          = "ephemeral/control-plane"
      description = "Allow nodes to receive communication from the cluster control plane."
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535

      source_security_group_id = module.security_group__control_plane.id
    },
    {
      id          = "cluster-api/control-plane"
      description = "Allow nodes to communicate with the cluster API server."
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443

      source_security_group_id = module.security_group__control_plane.id
    },
  ]
  egress_rules = [
    {
      id          = "all/all"
      description = "Allow nodes egress access to the Internet."
      protocol    = "-1"
      from_port   = 0
      to_port     = 0

      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

  tags = merge(
    {
      "Name"                                      = "eks-${var.cluster_name}-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    },
    var.tags,
  )
}
