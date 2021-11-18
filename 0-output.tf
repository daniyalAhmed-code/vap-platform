output "DEV_PORTAL_SITE_S3_BUCKET_NAME" {
  value = module.s3.DEV_PORTAL_SITE_S3_BUCKET_NAME

}

output "ARTIFACT_S3_BUCKET_NAME" {
  value = module.s3.ARTIFACT_S3_BUCKET_NAME
}

output "DEV_PORTAL_CUSTOMERS_TABLE_NAME" {
  value = module.dynamodb.DEV_PORTAL_CUSTOMERS_TABLE_NAME
}
output "DEV_PORTAL_CUSTOMERS_TABLE_ARN" {
  value = module.dynamodb.DEV_PORTAL_CUSTOMERS_TABLE_ARN
}

output "DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME" {
  value = module.dynamodb.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME

}
output "DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN" {
  value = module.dynamodb.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN
}

output "DEV_PORTAL_FEEDBACK_TABLE_NAME" {
  value = module.dynamodb.DEV_PORTAL_FEEDBACK_TABLE_NAME
}
output "DEV_PORTAL_FEEDBACK_TABLE_ARN" {
  value = module.dynamodb.DEV_PORTAL_FEEDBACK_TABLE_ARN
}
output "BUCKET_REGIONAL_DOMAIN_NAME" {
  value = module.s3.BUCEKT_REGIONAL_DOMAIN_NAME
}
output "TOPIC_NAME" {
  value = module.sns.TOPIC_ARN
}

output "kms_key_id" {
  description = "VAP Platform KMS Key ID"
  value       = module.kms.key_id
}

output "kms_key_arn" {
  description = "VAP Platform KMS Key ARN"
  value       = module.kms.key_arn
}

### WAF outpus
output "regional_waf_id" {
  description = "Regional WAF ID"
  value       = var.create_regional_waf ? module.waf_regional.waf_acl_id : null
}

output "global_waf_id" {
  description = "Global WAF ID"
  value       = var.create_global_waf ? module.waf_global.waf_acl_id : null
}
