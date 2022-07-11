provider "aws" {
  region = "us-east-1"
}


###################################################
# ECR Repository
###################################################

module "repository" {
  source = "../../modules/ecr-repository"
  # source  = "tedilabs/container/aws//modules/ecr-repository"
  # version = "~> 0.20.0"

  name = "examples/simple"

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
