provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "this" {}

data "aws_iam_policy_document" "ecr_repository_policy" {
  statement {
    sid    = "ReadonlyAccess"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root",
      ]
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:DescribeImages",
      "ecr:BatchGetImage",
      "ecr:DescribeImageScanFindings",
    ]
  }
}


###################################################
# ECR Repository
###################################################

module "repository" {
  source = "../../modules/ecr-repository"
  # source  = "tedilabs/container/aws//modules/ecr-repository"
  # version = "~> 0.20.0"

  name = "examples/simple"

  force_delete                = true
  image_tag_immutable_enabled = true
  image_scan_on_push_enabled  = false

  encryption_type    = "KMS"
  encryption_kms_key = null

  repository_policy = data.aws_iam_policy_document.ecr_repository_policy.json
  lifecycle_rules = [
    {
      priority         = 10
      description      = "Keep tagged 100 images."
      type             = "tagged"
      tag_prefixes     = ["v"]
      expiration_count = 100
    },
    {
      priority        = 20
      description     = "Expire untagged images older than 1 days."
      type            = "any"
      expiration_days = 1
    },
  ]

  tags = {
    "project" = "terraform-aws-container-examples"
  }
}
