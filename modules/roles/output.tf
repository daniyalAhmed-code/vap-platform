output "FLOW_LOGS_ROLE_ID" {
  value = aws_iam_role.flow_logs_role.id
}
output "ROLE_ARN" {
  value = aws_iam_role.flow_logs_role.arn
}

output "LAMBDA_ROLE_ARN" {
  value = aws_iam_role.lambda_role.arn
}

output "LAMBDA_ROLE_NAME" {
  value = aws_iam_role.lambda_role.name
}
output "FLOW_LOGS_ROLE_NAME" {
  value = aws_iam_role.flow_logs_role.name
}
