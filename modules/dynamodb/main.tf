resource "aws_dynamodb_table" "dynamo-dev-portal-customer-db-table" {
  name           = var.DEV_PORTAL_CUSTOMERS_TABLE_NAME
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"
  attribute {
    name = "Id"
    type = "S"
  }

}

resource "aws_dynamodb_table" "dynamo-pre-login-accounts-db-table" {
  name           = var.DEV_PORTAL_PRE_LOGIN_ACCOUNTS_TABLE_NAME
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

}


resource "aws_dynamodb_table" "dynamo-dev-portal-feedback-db-table" {
  name           = var.DEV_PORTAL_FEEDBACK_TABLE_NAME
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "Id"

  attribute {
    name = "Id"
    type = "S"
  }

  global_secondary_index {
    name            = "FeedbackIdIndex"
    hash_key        = "Id"
    write_capacity  = 5
    read_capacity   = 5
    projection_type = "KEYS_ONLY"

  }
}

