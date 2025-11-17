data "aws_cloudwatch_log_group" "this" {
  count = var.logging.enabled ? 1 : 0

  region = var.region

  name = "/aws/eks/${aws_eks_cluster.this.name}/cluster"
}
