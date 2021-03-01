resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_encryption_kms_key

  tags = merge(
    {
      "Name" = "eks-${var.cluster_name}-cluster"
    },
    var.tags,
  )
}
