provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "dst"
  region = "us-east-2"
}

data "aws_caller_identity" "src" {}
data "aws_caller_identity" "dst" {
  provider = aws.dst
}


###################################################
# ECR Registry
###################################################

module "registry_src" {
  source = "../../modules/ecr-registry"
  # source  = "tedilabs/container/aws//modules/ecr-registry"
  # version = "~> 0.27.0"

  replication_rules = [
    {
      destinations = [
        {
          account = module.registry_dst.id
          region  = "us-east-2"
        }
      ]
    }
  ]
}

module "registry_dst" {
  source = "../../modules/ecr-registry"
  # source  = "tedilabs/container/aws//modules/ecr-registry"
  # version = "~> 0.27.0"

  providers = {
    aws = aws.dst
  }

  replication_policies = [
    {
      account                 = data.aws_caller_identity.src.account_id
      allow_create_repository = true
      repositories            = ["allowed/*"]
    }
  ]
}
