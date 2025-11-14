###################################################
# Replication Policy
###################################################

data "aws_iam_policy_document" "replication" {
  count = length(var.replication_policies) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.replication_policies
    iterator = policy

    content {
      sid    = "ReplicationAccess${policy.value.account}"
      effect = "Allow"

      principals {
        type = "AWS"
        identifiers = [
          "arn:aws:iam::${policy.value.account}:root"
        ]
      }
      actions = (policy.value.allow_create_repository
        ? ["ecr:CreateRepository", "ecr:ReplicateImage"]
        : ["ecr:ReplicateImage"]
      )
      resources = [
        for repository in policy.value.repositories :
        "arn:aws:ecr:${local.region}:${local.account_id}:repository/${repository}"
      ]
    }
  }
}


###################################################
# Replication Rules
###################################################

resource "aws_ecr_replication_configuration" "this" {
  count = length(var.replication_rules) > 0 ? 1 : 0

  region = var.region

  replication_configuration {
    dynamic "rule" {
      for_each = var.replication_rules
      iterator = rule

      content {
        dynamic "destination" {
          for_each = rule.value.destinations

          content {
            registry_id = coalesce(destination.value.account, local.account_id)
            region      = destination.value.region
          }
        }

        dynamic "repository_filter" {
          for_each = rule.value.filters
          iterator = filter

          content {
            filter_type = filter.value.type
            filter      = filter.value.value
          }
        }
      }
    }
  }
}
