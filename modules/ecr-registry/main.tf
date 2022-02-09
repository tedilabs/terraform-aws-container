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

data "aws_iam_policy_document" "replication" {
  count = length(try(var.replication_policies, [])) > 0 ? 1 : 0

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
}

data "aws_iam_policy_document" "pull_through_cache" {
  count = length(try(var.pull_through_cache_policies, [])) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = try(var.pull_through_cache_policies, [])

    content {
      sid    = "PullThroughCacheAccess-${statement.key}"
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = try(statement.value.iam_entities, [])
      }
      actions = compact([
        try(statement.value.allow_create_repository, true) ? "ecr:CreateRepository" : null,
        "ecr:BatchImportUpstreamImage",
      ])
      resources = [
        for repository in statement.value.repositories :
        "arn:aws:ecr:${local.region}:${local.account_id}:repository/${repository}"
      ]
    }
  }
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = concat(
    try(data.aws_iam_policy_document.replication[*].json, []),
    try(data.aws_iam_policy_document.pull_through_cache[*].json, []),
  )

  override_json = var.policy
}

resource "aws_ecr_registry_policy" "this" {
  count = length(var.replication_policies) > 0 || length(var.pull_through_cache_policies) > 0 || var.policy != null ? 1 : 0

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


###################################################
# Pull Through Cache Rule
###################################################

locals {
  default_namespaces = {
    "quay.io"        = "quay"
    "public.ecr.aws" = "ecr-public"
  }
}

resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each = {
    for rule in var.pull_through_cache_rules :
    try(rule.namespace, local.default_namespaces[rule.upstream_url]) => rule
  }

  ecr_repository_prefix = each.key
  upstream_registry_url = each.value.upstream_url
}


###################################################
# Scanning Configuration
###################################################

resource "aws_ecr_registry_scanning_configuration" "this" {
  scan_type = var.scanning_type

  dynamic "rule" {
    for_each = length(var.scanning_on_push_filters) > 0 ? ["go"] : []

    content {
      scan_frequency = "SCAN_ON_PUSH"

      dynamic "repository_filter" {
        for_each = var.scanning_on_push_filters

        content {
          filter      = repository_filter.value
          filter_type = "WILDCARD"
        }
      }
    }
  }

  dynamic "rule" {
    for_each = length(var.scanning_continuous_filters) > 0 ? ["go"] : []

    content {
      scan_frequency = "CONTINUOUS_SCAN"

      dynamic "repository_filter" {
        for_each = var.scanning_continuous_filters

        content {
          filter      = repository_filter.value
          filter_type = "WILDCARD"
        }
      }
    }
  }
}
