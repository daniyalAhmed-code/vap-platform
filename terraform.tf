terraform {

   backend "s3" {
     bucket                      = "dani-dev-terraform-remote-state-centralised"
     key                         = "vap-platform-infra/us-east-1/{{ENV}}/terraform.tfstate"
     region                      = "us-east-1"
     encrypt                     = true
     dynamodb_table              = "daniyal-terraform-locks-centralized"
     
   }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.58.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"

  # assume_role {
  #   role_arn = var.DEPLOY_ROLE
  # }

  # default_tags {
  #   tags = {
  #     Environment     = "{{ENV}}"
  #     ManagedBy       = "cloud.automation@outscope.com"
  #     DeployedBy      = "terraform"
  #     Project         = "vap"
  #     Confidentiality = "c3"
  #     TaggingVersion  = "v2.3"
  #   }
  # }

#   skip_get_ec2_platforms      = true
#   skip_metadata_api_check     = true
#   skip_region_validation      = true
#   skip_credentials_validation = true
#   skip_requesting_account_id  = true
}

provider "aws" {
  alias  = "global_region"
  region = "us-east-1"

  # assume_role {
  #   role_arn = var.DEPLOY_ROLE
  # }

  # default_tags {
  #   tags = {
  #     Environment     = "{{ENV}}"
  #     ManagedBy       = "cloud.automation@outscope.com"
  #     DeployedBy      = "terraform"
  #     Project         = "vap"
  #     Confidentiality = "c3"
  #     TaggingVersion  = "v2.3"
  #   }
  # }
  # skip_get_ec2_platforms      = true
  # skip_metadata_api_check     = true
  # skip_region_validation      = true
  # skip_credentials_validation = true
  # skip_requesting_account_id  = true
}
