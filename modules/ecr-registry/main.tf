locals {
  metadata = {
    package = "terraform-aws-container"
    version = trimspace(file("${path.module}/../../VERSION"))
    module  = basename(path.module)
    name    = local.account_id
  }
  module_tags = {
    "module.terraform.io/package"   = local.metadata.package
    "module.terraform.io/version"   = local.metadata.version
    "module.terraform.io/name"      = local.metadata.module
    "module.terraform.io/full-name" = "${local.metadata.package}/${local.metadata.module}"
    "module.terraform.io/instance"  = local.metadata.name
  }
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {
  region = var.region
}

locals {
  account_id = data.aws_caller_identity.this.id
  region     = data.aws_region.this.region
}


###################################################
# Registry Policy
###################################################

resource "aws_ecr_account_setting" "registry_policy_scope" {
  region = var.region

  name  = "REGISTRY_POLICY_SCOPE"
  value = var.policy_version
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = compact([
    one(data.aws_iam_policy_document.replication[*].json),
    one(data.aws_iam_policy_document.pull_through_cache[*].json),
  ])

  override_policy_documents = var.policy != null ? [var.policy] : null
}

resource "aws_ecr_registry_policy" "this" {
  count = anytrue([
    length(var.replication_policies) > 0,
    length(var.pull_through_cache_policies) > 0,
    var.policy != null,
  ]) ? 1 : 0

  region = var.region

  policy = data.aws_iam_policy_document.this.json
}
