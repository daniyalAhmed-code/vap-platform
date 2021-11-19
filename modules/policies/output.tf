output "KMS_KEY_POLICY" {
    value = data.aws_iam_policy_document.kms_key_policy.json
}