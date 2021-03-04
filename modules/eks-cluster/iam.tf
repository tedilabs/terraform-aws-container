###################################################
# IAM OIDC Provider
###################################################

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
}


###################################################
# IAM Role for Control Plane
###################################################

module "role__control_plane" {
  source  = "tedilabs/account/aws//modules/iam-role"
  version = "0.8.0"

  name        = "eks-${var.cluster_name}-control-plane"
  path        = "/"
  description = "Role for the EKS cluster(${var.cluster_name}) control plane"

  trusted_services = ["eks.amazonaws.com"]

  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
  ]

  tags = merge(
    {
      "Name" = "eks-${var.cluster_name}-control-plane"
    },
    var.tags,
  )
}


###################################################
# IAM Role for Nodes
###################################################

module "role__node" {
  source  = "tedilabs/account/aws//modules/iam-role"
  version = "0.8.0"

  name        = "eks-${var.cluster_name}-node"
  path        = "/"
  description = "Role for the EKS cluster(${var.cluster_name}) nodes"

  trusted_services = ["ec2.amazonaws.com"]

  policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    # TODO: https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ]

  instance_profile_enabled = true

  tags = merge(
    {
      "Name" = "eks-${var.cluster_name}-node"
    },
    var.tags,
  )
}
