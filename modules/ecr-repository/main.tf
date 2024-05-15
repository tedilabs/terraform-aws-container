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
  name = local.metadata.name

  force_delete         = var.force_delete
  image_tag_mutability = var.image_tag_immutable_enabled ? "IMMUTABLE" : "MUTABLE"

  image_scanning_configuration {
    scan_on_push = var.image_scan_on_push_enabled
  }

  encryption_configuration {
    encryption_type = var.encryption.type
    kms_key         = var.encryption.kms_key
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

  repository = aws_ecr_repository.this.name
  policy     = var.policy
}


###################################################
# Lifecycle Policy
###################################################

locals {
  lifecycle_rules = [
    for rule in var.lifecycle_rules : {
      rulePriority = rule.priority
      description  = rule.description
      selection = {
        for k, v in {
          tagStatus = rule.target.status
          tagPatternList = (rule.target.status == "tagged" && length(rule.target.tag_patterns) > 0
            ? rule.target.tag_patterns
            : null
          )
          tagPrefixList = (rule.target.status == "tagged" && length(rule.target.tag_prefixes) > 0
            ? rule.target.tag_prefixes
            : null
          )

          countType = (rule.expiration.count != null
            ? "imageCountMoreThan"
            : "sinceImagePushed"
          )
          countUnit = (rule.expiration.count != null
            ? null
            : "days"
          )
          countNumber = (rule.expiration.count != null
            ? rule.expiration.count
            : rule.expiration.days
          )
        } :
        k => v
        if v != null
      }
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
