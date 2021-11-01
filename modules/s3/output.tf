output "BUCEKT_REGIONAL_DOMAIN_NAME"{
    value = aws_s3_bucket.dev_portal_s3_bucket.bucket_regional_domain_name
}


output "DEV_PORTAL_SITE_S3_BUCKET_NAME"{
    value = aws_s3_bucket.dev_portal_s3_bucket.id
}


output "ARTIFACT_S3_BUCKET_NAME"{
    value = aws_s3_bucket.artifact_s3_bucket.id
}
