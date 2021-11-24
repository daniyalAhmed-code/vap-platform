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
    enabled = true
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
    enabled = true
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
    enabled = true
    kms_key_arn = var.KMS_KEY_ARN
  }
}


resource "aws_dynamodb_table" "dynamo-customer-request-logs" {
  name           = var.DEV_PORTAL_CUSTOMER_REQUEST_LOGS_TABLE_NAME
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "user_id"
  range_key      = "epochtime"


  attribute {
    name = "user_id"
    type = "S"
  }
  
  attribute {
    name = "epochtime"
    type = "N"
  }
  
  attribute {
    name = "Mno"
    type = "S"
  }
    attribute {
    name = "MnoLocation"
    type = "S"
  }

  point_in_time_recovery {
    enabled = var.ENABLE_POINT_IN_TIME_RECOVERY
  }
  
  server_side_encryption {
    enabled = true
    kms_key_arn = var.KMS_KEY_ARN
  }
  global_secondary_index {
    name               = "User_Mno"
    hash_key           = "user_id"
    range_key          = "Mno"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["epochtime","RequestType","Headers","MultiValueHeaders","QueryStringParameters","Body","EmailAddress","ApiPath","MnoLocation","CreatedAt"]
  }
global_secondary_index {
    name               = "User_MnoLocation"
    hash_key           = "user_id"
    range_key          = "MnoLocation"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["epochtime","RequestType","Headers","MultiValueHeaders","QueryStringParameters","Body","EmailAddress","ApiPath","Mno","CreatedAt"]
  }


}

