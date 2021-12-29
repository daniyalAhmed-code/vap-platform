output "DEV_PORTAL_CUSTOMERS_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-dev-portal-customer-db-table.id
}
output "DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-pre-login-accounts-db-table.id
}
output "DEV_PORTAL_FEEDBACK_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-dev-portal-feedback-db-table.id
}
//HERE
output "API_PERMISSION_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-api-permissions-db-table.id
}

output "MNO_THIRD_PARTY_RESOURCE_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-mno-third-party-resource-db-table.id
}


output "DEV_PORTAL_CUSTOMERS_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-dev-portal-customer-db-table.arn
}
output "DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-pre-login-accounts-db-table.arn
}



output "API_PERMISSION_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-api-permissions-db-table.arn
}

output "MNO_THIRD_PARTY_RESOURCE_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-mno-third-party-resource-db-table.arn
}



dynamo-mno-third-party-resource-db-table

output "DEV_PORTAL_FEEDBACK_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-dev-portal-feedback-db-table.arn
}



output "DEV_PORTAL_CUSTOMER_REQUEST_LOGS_TABLE_ARN" {
  value = aws_dynamodb_table.dynamo-dev-portal-customer-db-table.arn
}
output "DEV_PORTAL_CUSTOMER_REQUEST_LOGS_TABLE_NAME" {
  value = aws_dynamodb_table.dynamo-pre-login-accounts-db-table.id
}

