resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/eks/${local.metadata.name}/cluster"
  retention_in_days = var.log_retention_in_days
  kms_key_id        = var.log_encryption_kms_key

  tags = merge(
    {
      "Name" = "eks-${local.metadata.name}-cluster"
    },
    local.module_tags,
    var.tags,
  )
}
