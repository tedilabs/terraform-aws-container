provider "aws" {
  region = "us-east-1"
}


###################################################
# ECR Repository
###################################################

module "repository" {
  source = "../../modules/ecr-repository"
  # source  = "tedilabs/container/aws//modules/ecr-repository"
  # version = "~> 0.19.0"

  name = "examples/simple"

  tags = {
    "project" = "terraform-aws-container-examples"
  }
}
