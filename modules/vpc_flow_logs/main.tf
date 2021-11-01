resource "aws_flow_log" "cloudwatch_log" {
  count           = var.ENABLE_VPC_FLOW_LOGS_IN_CLOUDWATCH ? 1 : 0
  iam_role_arn    = var.ROLE_ARN
  log_destination = var.VPC_FLOW_LOGS_CLOUDWATCH
  traffic_type    = "ALL"
  vpc_id          = var.VPC_ID
}

resource "aws_flow_log" "s3_log" {
  count                = var.ENABLE_VPC_FLOW_LOGS_IN_BUCKET ? 1 : 0
  log_destination      = var.FLOW_LOGS_BUCKET_ARN
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = var.VPC_ID
}



