provider "aws" {
  region = "us-east-1"
}


###################################################
# ECR Registry
###################################################

module "registry" {
  source = "../../modules/ecr-registry"
  # source  = "tedilabs/container/aws//modules/ecr-registry"
  # version = "~> 0.19.0"

  scanning_type = "BASIC"

  tags = {
    "project" = "terraform-aws-container-examples"
  }
}
