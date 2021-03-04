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
  version = "0.8.0"

  name        = var.name
  path        = var.path
  description = var.description

  max_session_duration  = var.max_session_duration
  force_detach_policies = var.force_detach_policies
  permissions_boundary  = var.permissions_boundary

  trusted_oidc_providers = local.trusted_oidc_providers
  trusted_oidc_conditions = concat(
    local.trusted_app_id_condition,
    local.trusted_service_accounts_condition,
    var.trusted_oidc_conditions
  )
  conditions = var.conditions

  effective_date      = var.effective_date
  expiration_date     = var.expiration_date
  source_ip_whitelist = var.source_ip_whitelist
  source_ip_blacklist = var.source_ip_blacklist

  policies        = var.policies
  inline_policies = var.inline_policies

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags,
  )
}
