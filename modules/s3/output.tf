output "BUCEKT_REGIONAL_DOMAIN_NAME" {
  value = aws_s3_bucket.dev_portal_s3_bucket.bucket_regional_domain_name
}


output "DEV_PORTAL_SITE_S3_BUCKET_NAME" {
  value = aws_s3_bucket.dev_portal_s3_bucket.id
}


output "ARTIFACT_S3_BUCKET_NAME" {
  value = aws_s3_bucket.artifact_s3_bucket.id
}


output "IP_LIST_BUCKET" {
  value = aws_s3_bucket.ip_list_bucket.arn
}
output "IP_LIST_BUCKET_ID" {
  value = aws_s3_bucket.ip_list_bucket.id
}


output "VPC_FLOW_LOGS_BUCKET_ARN" {
  value = length(aws_s3_bucket.vpc_flow_logs) > 0 ? aws_s3_bucket.vpc_flow_logs[0].arn : ""
}
output "VPC_FLOW_LOGS_BUCKET_ID" {
  value = length(aws_s3_bucket.vpc_flow_logs) > 0 ? aws_s3_bucket.vpc_flow_logs[0].id : ""
}
