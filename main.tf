locals{
    AWS_REGION = "${data.aws_region.current.name}"
    CURRENT_ACCOUNT_ID = "${data.aws_caller_identity.current.account_id}"
    RESOURCE_PREFIX =  "${lower(var.ENV)}"
    DEV_PORTAL_CUSTOMERS_TABLE_NAME = "${local.RESOURCE_PREFIX}-vap-user"
    DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = "${local.RESOURCE_PREFIX}-vap-prelogin-account"
    DEV_PORTAL_FEEDBACK_TABLE_NAME = "${local.RESOURCE_PREFIX}-vap-feedback"
    DEV_PORTAL_SITE_S3_BUCKET_NAME = "${local.RESOURCE_PREFIX}-vap-portal"
    ARTIFACT_S3_BUCKET_NAME = "${local.RESOURCE_PREFIX}-vap-artifacts-bucket"
    SNS_TOPIC_NAME = "${local.RESOURCE_PREFIX}-vap-send-feedback-email"
}


module "dynamodb"{
  source ="./modules/dynamodb"

  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  DEV_PORTAL_CUSTOMERS_TABLE_NAME = local.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME = local.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  DEV_PORTAL_FEEDBACK_TABLE_NAME = local.DEV_PORTAL_FEEDBACK_TABLE_NAME
  
}

module "sns"{
  source ="./modules/sns"
  ENABLE_FEEDBACK_SUBMISSION = var.ENABLE_FEEDBACK_SUBMISSION
  TOPIC_NAME = local.SNS_TOPIC_NAME
  EMAIL_ENDPOINT = var.EMAIL_ENDPOINT
}
module "s3"{
  source ="./modules/s3"

  DEV_PORTAL_SITE_S3_BUCKET_NAME = local.DEV_PORTAL_SITE_S3_BUCKET_NAME
  ARTIFACT_S3_BUCKET_NAME = local.ARTIFACT_S3_BUCKET_NAME
}