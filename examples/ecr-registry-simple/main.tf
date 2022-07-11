provider "aws" {
  region = "us-east-1"
}


###################################################
# ECR Registry
###################################################

module "registry" {
  source = "../../modules/ecr-registry"
  # source  = "tedilabs/container/aws//modules/ecr-registry"
  # version = "~> 0.20.0"

  scanning_type = "BASIC"
}
