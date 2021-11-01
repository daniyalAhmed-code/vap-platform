resource "aws_s3_bucket" "dev_portal_s3_bucket" {
  bucket = var.DEV_PORTAL_SITE_S3_BUCKET_NAME
  acl    = "private"
  force_destroy  = true
}
resource "aws_s3_bucket_public_access_block" "dev_protal_bucket" {
  bucket = aws_s3_bucket.dev_portal_s3_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "artifact_s3_bucket" {
  bucket = var.ARTIFACT_S3_BUCKET_NAME
  acl    = "private"
  force_destroy  = true
}
resource "aws_s3_bucket_public_access_block" "artifact_bucket" {
  bucket = aws_s3_bucket.artifact_s3_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true

}