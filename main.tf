locals {
  AWS_REGION                               = data.aws_region.current.name
  CURRENT_ACCOUNT_ID                       = data.aws_caller_identity.current.account_id
  RESOURCE_PREFIX                          = "vap-${lower(var.ENV)}"
  DEV_PORTAL_CUSTOMERS_TABLE_NAME          = "${local.RESOURCE_PREFIX}-user"
  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = "${local.RESOURCE_PREFIX}-prelogin-account"
  API_PERMISSION_TABLE_NAME                = "${local.RESOURCE_PREFIX}-api-permission"
  MNO_THIRD_PARTY_TABLE_NAME                = "${local.RESOURCE_PREFIX}-resources"
  
  DEV_PORTAL_FEEDBACK_TABLE_NAME           = "${local.RESOURCE_PREFIX}-feedback"
  DEV_PORTAL_CUSTOMER_REQUEST_LOGS_TABLE_NAME = "${local.RESOURCE_PREFIX}-customer-request-log"
  DEV_PORTAL_SITE_S3_BUCKET_NAME           = "${local.RESOURCE_PREFIX}-portal"
  ARTIFACT_S3_BUCKET_NAME                  = "${local.RESOURCE_PREFIX}-artifacts-bucket"
  SNS_TOPIC_NAME                           = "${local.RESOURCE_PREFIX}-send-feedback-email"
  # TRUSTED_ROLE_ACTIONS                     =
  # TRUSTED_ROLE_ACTIONS                     =
  # TRUSTED_ROLE_ACTIONS                     =
}


module "dynamodb" {
  source                                   = "./modules/dynamodb"
  RESOURCE_PREFIX                          = local.RESOURCE_PREFIX
  DEV_PORTAL_CUSTOMERS_TABLE_NAME          = local.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = local.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  DEV_PORTAL_FEEDBACK_TABLE_NAME           = local.DEV_PORTAL_FEEDBACK_TABLE_NAME
  ENABLE_POINT_IN_TIME_RECOVERY            = var.ENABLE_POINT_IN_TIME_RECOVERY
  KMS_KEY_ARN                              = module.kms.key_arn
  DEV_PORTAL_CUSTOMER_REQUEST_LOGS_TABLE_NAME = local.DEV_PORTAL_CUSTOMER_REQUEST_LOGS_TABLE_NAME
  API_PERMISSION_TABLE_NAME                   = local.API_PERMISSION_TABLE_NAME
  MNO_THIRD_PARTY_TABLE_NAME                  = local.MNO_THIRD_PARTY_TABLE_NAME
}

module "sns" {
  source                     = "./modules/sns"
  ENABLE_FEEDBACK_SUBMISSION = var.ENABLE_FEEDBACK_SUBMISSION
  TOPIC_NAME                 = local.SNS_TOPIC_NAME
  EMAIL_ENDPOINT             = var.EMAIL_ENDPOINT
}

module "s3" {
  source                         = "./modules/s3"
  DEV_PORTAL_SITE_S3_BUCKET_NAME = local.DEV_PORTAL_SITE_S3_BUCKET_NAME
  ARTIFACT_S3_BUCKET_NAME        = local.ARTIFACT_S3_BUCKET_NAME
  RESOURCE_PREFIX                = local.RESOURCE_PREFIX
  ENABLE_VPC_FLOW_LOGS_IN_BUCKET = var.ENABLE_VPC_FLOW_LOGS_IN_BUCKET
  CURRENT_ACCOUNT_ID             = data.aws_caller_identity.current.account_id
  S3_LOGGING_BUCKET              = var.S3_LOGGING_BUCKET
  KMS_KEY_ID                     = module.kms.key_id
  KMS_KEY_ARN                    = module.kms.key_arn
}

module "vpc" {
  source          = "./modules/vpc"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  CIDR_BLOCK      = var.CIDR_BLOCK
  PRIVATE_SUBNETS = var.PRIVATE_SUBNETS
  PUBLIC_SUBNETS  = var.PUBLIC_SUBNETS
  REGION          = data.aws_region.current.name
}

module "roles" {
  source          = "./modules/roles"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  # VPC_CONFIG_LAMBDA_POLICY_DOCUMENT = module.policy.VPC_CONFIG_LAMBDA_POLICY_DOCUMENT

}

module "policy" {
  source              = "./modules/policies"
  RESOURCE_PREFIX     = local.RESOURCE_PREFIX
  NLB_TARGET_ARN      = module.load_balancer.target_group_arn
  IP_LIST_BUCKET      = module.s3.IP_LIST_BUCKET
  LAMBDA_ROLE_NAME    = module.roles.LAMBDA_ROLE_NAME
  FLOW_LOGS_ROLE_NAME = module.roles.FLOW_LOGS_ROLE_NAME
  AWS_REGION          = local.AWS_REGION
  CURRENT_ACCOUNT_ID  = local.CURRENT_ACCOUNT_ID
  # TRUSTED_ROLE_ACTIONS = local.TRUSTED_ROLE_ACTIONS
  # TRUSTED_ROLE_ARNS    = local.TRUSTED_ROLE_ARNS
  # TRUSTED_ROLE_SERVICES = local.TRUSTED_ROLE_SERVICES
}

module "load_balancer" {
  source                 = "./modules/load_balancer"
  SUBNET_MAPPING         = module.vpc.public_subnet
  PRIVATE_SUBNET_MAPPING = module.vpc.private_subnet
  VPC_ID                 = module.vpc.id
  SG_ID                  = module.vpc.SG_ID
  RESOURCE_PREFIX        = local.RESOURCE_PREFIX
}

module "vpc_flow_logs" {
  source                             = "./modules/vpc_flow_logs"
  VPC_ID                             = module.vpc.id
  CURRENT_ACCOUNT_ID                 = data.aws_caller_identity.current.account_id
  RESOURCE_PREFIX                    = local.RESOURCE_PREFIX
  ROLE_ARN                           = module.roles.ROLE_ARN
  FLOW_LOGS_BUCKET_ARN               = module.s3.VPC_FLOW_LOGS_BUCKET_ARN
  VPC_FLOW_LOGS_CLOUDWATCH           = module.cw.VPC_FLOW_LOGS_CLOUDWATCH
  ENABLE_VPC_FLOW_LOGS_IN_CLOUDWATCH = var.ENABLE_VPC_FLOW_LOGS_IN_CLOUDWATCH
  ENABLE_VPC_FLOW_LOGS_IN_BUCKET     = var.ENABLE_VPC_FLOW_LOGS_IN_BUCKET
}


module "lambda" {
  source            = "./modules/lambda"
  NLB_TARGET_ARN    = module.load_balancer.target_group_arn
  RESOURCE_PREFIX   = local.RESOURCE_PREFIX
  ALB_LISTENER      = 443
  ALB_DNS_NAME      = module.load_balancer.dns_name
  LAMBDA_ROLE_ARN   = module.roles.LAMBDA_ROLE_ARN
  IP_LIST_BUCKET_ID = module.s3.IP_LIST_BUCKET_ID
}


module "cw" {
  source                             = "./modules/cw"
  LAMBDA_FUNCTION_NAME               = module.lambda.NLB_ALB_CONNECTOR_LAMBDA_NAME
  RESOURCE_PREFIX                    = local.RESOURCE_PREFIX
  LAMBDA_FUNCTION_ARN                = module.lambda.NLB_ALB_CONNECTOR_LAMBDA_ARN
  ENABLE_VPC_FLOW_LOGS_IN_CLOUDWATCH = var.ENABLE_VPC_FLOW_LOGS_IN_CLOUDWATCH
  CURRENT_ACCOUNT_ID                 = data.aws_caller_identity.current.account_id
  KMS_KEY_ARN                        = module.kms.key_arn
  depends_on = [module.policy]
}

module "kms" {
  source                  = "cloudposse/kms-key/aws"
  version                 = "0.11.0"
  name                    = "vap-platform-key"
  description             = "KMS key to encrypt data in VAP platform"
  deletion_window_in_days = var.kms_deletion_windows_in_days
  enable_key_rotation     = true
  alias                   = "alias/vap-platform-key"
  policy                  = module.policy.KMS_KEY_POLICY
}

### WAF ###
## Regional Waf
module "waf_regional" {
  create = var.create_regional_waf
  source = "./modules/waf"

  name        = "vap-waf-regional"
  is_regional = true
}

## Global Waf
module "waf_global" {
  create = var.create_global_waf
  source = "./modules/waf"

  name        = "vap-waf-global"
  is_regional = false
  providers = {
    aws = aws.global_region
  }
}



#vap-connector

#################
#### IAM ####
#################
module "policy_invoke_lambda" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version     = "4.5.0"
  name        = "${local.RESOURCE_PREFIX}-api-gateway-lambda-policy"
  path        = "/"
  description = "Policy to invoke lambda"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:invokeFunction"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

module "lambda_execution_role" {
  source            = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version           = "4.5.0"
  create_role       = true
  role_name         = "${local.RESOURCE_PREFIX}-apigateway-lambda-execution-role"
  role_requires_mfa = false
  trusted_role_services = [
    "apigateway.amazonaws.com"
  ]
  custom_role_policy_arns = [
    module.policy_invoke_lambda.arn
  ]
  number_of_custom_role_policy_arns = 1
}

################
### Lambdas ####
################
# TODO : Lambda 3.9 Docker Image Not publish yet
# https://hub.docker.com/r/lambci/lambda/tags?page=1&ordering=last_updated
# ISSUE: https://github.com/lambci/lambci/issues/138
# PR: https://github.com/lambci/lambci/pull/139
module "simple_salesforce_lambda_layer" {
  source              = "./vendor/lambda"
  create_function     = false
  create_layer        = true
  layer_name          = "simple-salesforce-lambda-layer"
  description         = "Lambda layer with Simple Salesforce library"
  runtime             = var.lambda_runtime
  compatible_runtimes = var.layer_compatible_runtimes
  source_path = {
    pip_requirements = "lambdas/layers/simple-salesforce/requirements.txt",
    prefix_in_zip    = "python"
  }
  hash_extra      = sha256(file("lambdas/layers/simple-salesforce/requirements.txt"))
  build_in_docker = true
 
}

module "utils_lambda_layer" {
  source              = "./vendor/lambda"
  create_function     = false
  create_layer        = true
  layer_name          = "utils-lambda-layer"
  description         = "Lambda layer with some util modules"
  compatible_runtimes = var.layer_compatible_runtimes
  source_path = {
    path             = "${path.module}/lambdas/layers/utils",
    pip_requirements = false
    prefix_in_zip    = "python/utils"
  }
  build_in_docker = true
}

########################
#### API Usage Plan ####
########################
module "api_usage_plan" {
  depends_on = [
    module.api_device_type
  ]
  source      = "./vendor/modules/api-usage-plan"
  name        = "${local.RESOURCE_PREFIX}-${var.ENV}-st-usage-plan-01"
  description = "SiteTracker Endpoint API Usage PLAN"
  apis = [
    {
      id    = module.api_device_type.id
      stage = module.api_device_type.stage
    },
    {
      id    = module.api_activity.id
      stage = module.api_activity.stage
    },
    {
      id    = module.api_activity_outbound.id
      stage = module.api_activity_outbound.stage
    },
    {
      id    = module.api_project.id
      stage = module.api_project.stage
    },
    {
      id    = module.api_project_outbound.id
      stage = module.api_project_outbound.stage
    }
  ]
}