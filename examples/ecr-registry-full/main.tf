provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "this" {}


###################################################
# ECR Registry
###################################################

module "registry" {
  source = "../../modules/ecr-registry"
  # source  = "tedilabs/container/aws//modules/ecr-registry"
  # version = "~> 0.20.0"

  ## Replication
  replication_destinations = []
  replication_policies = [
    {
      account_id              = data.aws_caller_identity.this.account_id
      allow_create_repository = true
      repositories            = ["allowed/*"]
    }
  ]

  ## Pull-through Cache
  pull_through_cache_policies = [
    {
      # Specify one or more IAM principals to grant permission. Support the ARN of IAM entities, or AWS account ID.
      iam_entities            = [data.aws_caller_identity.this.account_id]
      allow_create_repository = true
      repositories = [
        "ecr-public/amazonlinux/*",
        "ecr-public/aws-ec2/aws-node-termination-handler",
        "quay/*",
      ]

    }
  ]
  pull_through_cache_rules = [
    {
      namespace    = "ecr-public"
      upstream_url = "public.ecr.aws"
    },
    {
      namespace    = "quay"
      upstream_url = "quay.io"
    },
  ]

  ## Scanning
  scanning_type               = "ENHANCED"
  scanning_on_push_filters    = ["quay/*", "sre/*"]
  scanning_continuous_filters = ["example/example"]
}
