###################################################
# IAM Role for Pull Through Cache Rules
###################################################

module "role__pull_through_cache" {
  count = var.default_pull_through_cache_role.enabled ? 1 : 0

  source  = "tedilabs/account/aws//modules/iam-role"
  version = "~> 0.33.0"

  name = coalesce(
    var.default_pull_through_cache_role.name,
    "ecr-registry-pull-through-cache-${local.metadata.name}",
  )
  path        = var.default_pull_through_cache_role.path
  description = var.default_pull_through_cache_role.description

  trusted_service_policies = [
    {
      services = ["pullthroughcache.ecr.amazonaws.com"]
    },
  ]

  policies = var.default_pull_through_cache_role.policies
  inline_policies = merge(
    {
      "pull-through-cache" = data.aws_iam_policy_document.pull_through_cache_ecr[0].json
    },
    var.default_pull_through_cache_role.inline_policies
  )

  permissions_boundary = var.default_pull_through_cache_role.permissions_boundary

  force_detach_policies = true
  resource_group = {
    enabled = false
  }
  module_tags_enabled = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}


###################################################
# IAM Policies
###################################################

data "aws_iam_policy_document" "pull_through_cache_ecr" {
  count = var.default_pull_through_cache_role.enabled ? 1 : 0

  statement {
    sid = "PullThroughCacheAccess"

    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchImportUpstreamImage",
      "ecr:BatchGetImage",
      "ecr:GetImageCopyStatus",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage",
    ]
    resources = ["*"]
  }
}
