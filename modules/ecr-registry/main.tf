locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = data.aws_caller_identity.this.id
  }
  module_tags = var.module_tags_enabled ? {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  } : {}
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

locals {
  account_id = data.aws_caller_identity.this.id
  region     = data.aws_region.this.name
}


###################################################
# Registry Policy
###################################################

data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = try(var.replication_policies, [])

    content {
      sid    = "ReplicationAccess${statement.value.account_id}"
      effect = "Allow"
      principals {
        type = "AWS"
        identifiers = [
          "arn:aws:iam::${statement.value.account_id}:root"
        ]
      }
      actions = compact([
        try(statement.value.allow_create_repository, true) ? "ecr:CreateRepository" : null,
        "ecr:ReplicateImage",
      ])
      resources = [
        for repository in statement.value.repositories :
        "arn:aws:ecr:${local.region}:${local.account_id}:repository/${repository}"
      ]
    }
  }

  override_json = var.policy
}

resource "aws_ecr_registry_policy" "this" {
  count = length(var.replication_policies) > 0 || var.policy != null ? 1 : 0

  policy = data.aws_iam_policy_document.this.json
}


###################################################
# Replication Configurations
###################################################

resource "aws_ecr_replication_configuration" "this" {
  count = length(var.replication_destinations) > 0 ? 1 : 0

  replication_configuration {
    rule {
      dynamic "destination" {
        for_each = var.replication_destinations

        content {
          registry_id = destination.value.registry_id
          region      = destination.value.region
        }
      }
    }
  }
}
