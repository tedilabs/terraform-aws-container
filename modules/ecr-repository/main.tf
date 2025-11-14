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


###################################################
# ECR Repository
###################################################

resource "aws_ecr_repository" "this" {
  region = var.region

  name = local.metadata.name

  force_delete         = var.force_delete
  image_tag_mutability = var.image_tag_mutability.mode

  dynamic "image_tag_mutability_exclusion_filter" {
    for_each = var.image_tag_mutability.exclusion_filters
    iterator = filter

    content {
      filter_type = filter.value.type
      filter      = filter.value.value
    }
  }

  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push_enabled
  }

  encryption_configuration {
    encryption_type = var.encryption.type
    kms_key = (var.encryption.type == "KMS"
      ? var.encryption.kms_key
      : null
    )
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
  count = length(var.policy) > 0 ? 1 : 0

  region = var.region

  repository = aws_ecr_repository.this.name
  policy     = var.policy
}


###################################################
# Lifecycle Policy
###################################################

data "aws_ecr_lifecycle_policy_document" "this" {
  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
      priority    = rule.value.priority
      description = rule.value.description

      selection {
        tag_status = rule.value.target.status
        tag_pattern_list = (rule.value.target.status == "tagged" && length(rule.value.target.tag_patterns) > 0
          ? rule.value.target.tag_patterns
          : null
        )
        tag_prefix_list = (rule.value.target.status == "tagged" && length(rule.value.target.tag_prefixes) > 0
          ? rule.value.target.tag_prefixes
          : null
        )
        count_type = (rule.value.expiration.count != null
          ? "imageCountMoreThan"
          : "sinceImagePushed"
        )
        count_unit = (rule.value.expiration.count != null
          ? null
          : "days"
        )
        count_number = (rule.value.expiration.count != null
          ? rule.value.expiration.count
          : rule.value.expiration.days
        )
      }

      action {
        type = "expire"
      }
    }
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  region = var.region

  repository = aws_ecr_repository.this.name
  policy     = data.aws_ecr_lifecycle_policy_document.this.json
}
