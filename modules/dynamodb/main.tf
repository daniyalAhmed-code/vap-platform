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
  
  point_in_time_recovery {
    enabled = var.ENABLE_POINT_IN_TIME_RECOVERY
  }
  
  server_side_encryption {
    enabled = false
    kms_key_arn = var.KMS_KEY_ARN
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
  
  point_in_time_recovery {
    enabled = var.ENABLE_POINT_IN_TIME_RECOVERY
  }
  
  server_side_encryption {
    enabled = false
    kms_key_arn = var.KMS_KEY_ARN
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
  
  point_in_time_recovery {
    enabled = var.ENABLE_POINT_IN_TIME_RECOVERY
  }
  
  server_side_encryption {
    enabled = false
    kms_key_arn = var.KMS_KEY_ARN
  }
}

resource "aws_dynamodb_table" "dynamo-customer-request-logs-db-table" {
  name           = var.DEV_PORTAL_CUSTOMER_REQUEST_LOGS_TABLE_NAME
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "RequestId"
  range_key      = "Username_RequestTime"


  attribute {
    name = "UserId"
    type = "S"
  }
  
  attribute {
    name = "Username_RequestTime"
    type = "S"
  }
  
  point_in_time_recovery {
    enabled = var.ENABLE_POINT_IN_TIME_RECOVERY
  }
  
  server_side_encryption {
    enabled = true
    kms_key_arn = var.KMS_KEY_ARN
  }

}