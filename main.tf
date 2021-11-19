locals {
  AWS_REGION                               = data.aws_region.current.name
  CURRENT_ACCOUNT_ID                       = data.aws_caller_identity.current.account_id
  RESOURCE_PREFIX                          = "vap-${lower(var.ENV)}"
  DEV_PORTAL_CUSTOMERS_TABLE_NAME          = "${local.RESOURCE_PREFIX}-user"
  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = "${local.RESOURCE_PREFIX}-prelogin-account"
  DEV_PORTAL_FEEDBACK_TABLE_NAME           = "${local.RESOURCE_PREFIX}-feedback"
  DEV_PORTAL_SITE_S3_BUCKET_NAME           = "${local.RESOURCE_PREFIX}-portal"
  ARTIFACT_S3_BUCKET_NAME                  = "${local.RESOURCE_PREFIX}-artifacts-bucket"
  SNS_TOPIC_NAME                           = "${local.RESOURCE_PREFIX}-send-feedback-email"
}


module "dynamodb" {
  source                                   = "./modules/dynamodb"
  RESOURCE_PREFIX                          = local.RESOURCE_PREFIX
  DEV_PORTAL_CUSTOMERS_TABLE_NAME          = local.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = local.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  DEV_PORTAL_FEEDBACK_TABLE_NAME           = local.DEV_PORTAL_FEEDBACK_TABLE_NAME
  ENABLE_POINT_IN_TIME_RECOVERY            = var.ENABLE_POINT_IN_TIME_RECOVERY
  KMS_KEY_ARN                              = module.kms.key_arn
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
