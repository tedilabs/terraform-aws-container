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

  # Use default AWS-managed KMS key `aws/ecr`
  encryption_type    = "KMS"
  encryption_kms_key = null

  tags = {
    "project" = "terraform-aws-container-examples"
  }
}
