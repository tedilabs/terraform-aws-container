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

locals {
  trusted_oidc_providers = [
    for url in var.oidc_provider_urls : {
      type = "aws-iam"
      url  = url
    }
  ]
  trusted_app_id_condition = [{
    key       = "aud"
    condition = "StringEquals"
    values    = ["sts.amazonaws.com"]
  }]
  trusted_service_accounts_condition = [{
    key       = "sub"
    condition = "StringLike"
    values = [
      for account in var.trusted_service_accounts :
      "system:serviceaccount:${account}"
    ]
  }]
}


###################################################
# IAM Role for EKS IRSA
###################################################

module "this" {
  source  = "tedilabs/account/aws//modules/iam-role"
  version = "0.19.0"

  name        = local.metadata.name
  path        = var.path
  description = var.description

  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary

  trusted_iam_entities   = var.trusted_iam_entities
  trusted_oidc_providers = local.trusted_oidc_providers
  trusted_oidc_conditions = concat(
    local.trusted_app_id_condition,
    local.trusted_service_accounts_condition,
    var.trusted_oidc_conditions
  )
  conditions = var.conditions

  mfa_required        = var.mfa_required
  mfa_ttl             = var.mfa_ttl
  effective_date      = var.effective_date
  expiration_date     = var.expiration_date
  source_ip_whitelist = var.source_ip_whitelist
  source_ip_blacklist = var.source_ip_blacklist

  assumable_roles = var.assumable_roles
  policies        = var.policies
  inline_policies = var.inline_policies

  resource_group_enabled = false
  module_tags_enabled    = false

  tags = merge(
    local.module_tags,
    var.tags,
  )
}
