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
}
