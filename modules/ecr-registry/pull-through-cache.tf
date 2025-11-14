###################################################
# Pull Through Cache Policy
###################################################

data "aws_iam_policy_document" "pull_through_cache" {
  count = length(var.pull_through_cache_policies) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.pull_through_cache_policies
    iterator = policy

    content {
      sid    = "PullThroughCacheAccess-${policy.key}"
      effect = "Allow"

      principals {
        type        = "AWS"
        identifiers = policy.value.iam_entities
      }
      actions = concat(
        policy.value.allow_create_repository ? ["ecr:CreateRepository"] : [],
        (policy.value.allow_cross_account_pull_through_cache
          ? [
            "ecr:BatchGetImage",
            "ecr:BatchImportUpstreamImage",
            "ecr:GetDownloadUrlForLayer",
            "ecr:GetImageCopyStatus",
          ]
          : ["ecr:BatchImportUpstreamImage"]
        )
      )
      resources = [
        for repository in policy.value.repositories :
        "arn:aws:ecr:${local.region}:${local.account_id}:repository/${repository}"
      ]
    }
  }
}


###################################################
# Pull Through Cache Rules
###################################################

locals {
  default_namespaces = {
    "ghcr.io"              = "github"
    "public.ecr.aws"       = "ecr-public"
    "quay.io"              = "quay"
    "registry-1.docker.io" = "docker-hub"
    "registry.gitlab.com"  = "gitlab"
    "registry.k8s.io"      = "kubernetes"
    # "<my-registry>.azurecr.io" = "azure"
    # "<aws_account_id>.dkr.ecr.<region>.amazonaws.com" = "ecr"
  }
}

resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each = {
    for rule in var.pull_through_cache_rules :
    coalesce(rule.namespace, local.default_namespaces[rule.upstream_url]) => rule
  }

  region = var.region

  ecr_repository_prefix = each.key
  upstream_registry_url = each.value.upstream_url
  upstream_repository_prefix = (endswith(each.value.upstream_url, "amazonaws.com")
    ? each.value.upstream_prefix
    : null
  )

  credential_arn = (each.value.credential != null
    ? each.value.credential.secretsmanager_secret
    : null
  )
  custom_role_arn = (each.value.credential != null
    ? each.value.credential.iam_role
    : null
  )
}
