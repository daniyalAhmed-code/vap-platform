output "DEV_PORTAL_CUSTOMERS_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-dev-portal-customer-db-table.id
}
output "DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-pre-login-accounts-db-table.id
}
output "DEV_PORTAL_FEEDBACK_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-dev-portal-feedback-db-table.id
}

output "DEV_PORTAL_CUSTOMERS_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-dev-portal-customer-db-table.arn
}
output "DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-pre-login-accounts-db-table.arn
}
output "DEV_PORTAL_FEEDBACK_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-dev-portal-feedback-db-table.arn
}



output "API_PERMISSION_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-api-permission-db-table.id
}

output "API_PERMISSION_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-api-permission-db-table.arn
}

output "API_ROLE_PERMISSION_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-api-authorizer-db-table.id
}

output "API_ROLE_PERMISSION_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-api-authorizer-db-table.arn
}


output "MNO_THIRD_PARTY_RESOURCE_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-mno-third-party-resource-db-table.id
}

output "MNO_THIRD_PARTY_RESOURCE_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-mno-third-party-resource-db-table.arn
}