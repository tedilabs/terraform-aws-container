locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = var.name
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

resource "aws_ecr_repository" "this" {
  name = local.metadata.name

  image_tag_mutability = var.image_tag_immutable_enabled ? "IMMUTABLE" : "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push_enabled
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_enabled ? ["go"] : []

    content {
      encryption_type = var.encryption_type
      kms_key         = var.encryption_kms_key
    }
  }

  tags = merge(
    {
      "Name" = local.metadata.name
    },
    local.module_tags,
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

locals {
  lifecycle_rules = [
    for rule in var.lifecycle_rules : {
      rulePriority = tonumber(rule.priority)
      description  = rule.description
      selection = merge(
        {
          tagStatus = rule.type
        },
        try(
          {
            tagPrefixList = rule.tag_prefixes
          },
          {}
        ),
        try(
          {
            countType   = "imageCountMoreThan"
            countNumber = tonumber(rule.expiration_count)
          },
          {
            countType   = "sinceImagePushed"
            countUnit   = "days"
            countNumber = tonumber(rule.expiration_days)
          }
        )
      )
      action = {
        type = "expire"
      }
    }
  ]
  lifecycle_policy = jsonencode({
    rules = local.lifecycle_rules
  })
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = length(local.lifecycle_policy) >= 100 ? 1 : 0

  repository = aws_ecr_repository.this.name
  policy     = local.lifecycle_policy
}
