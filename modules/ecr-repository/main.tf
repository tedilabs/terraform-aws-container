resource "aws_ecr_repository" "this" {
  name = var.name

  image_tag_mutability = var.image_tag_immutable_enabled ? "IMMUTABLE" : "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push_enabled
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_enalbed ? ["go"] : []

    content {
      encryption_type = var.encryption_type
      kms_key         = var.encryptoin_kms_key
    }
  }

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}


###################################################
# Repository Policy
###################################################

resource "aws_ecr_repository_policy" "this" {
  count = length(var.repository_policy) > 0 ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = var.repository_policy
}


###################################################
# Lifecycle Policy
###################################################

resource "aws_ecr_lifecycle_policy" "this" {
  count = length(var.lifecycle_policy) > 0 ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = var.lifecycle_policy
}
