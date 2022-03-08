###################################################
# IRSA OIDC Provider
###################################################

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]

  tags = merge(
    {
      "Name" = "eks-${local.metadata.name}-oidc-provider"
    },
    local.module_tags,
    var.tags,
  )
}
