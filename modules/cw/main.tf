#############################################
#### CloudWatch Event to trigger Lambda ####
#############################################
resource "aws_cloudwatch_event_rule" "trigger_nlb_alb_connector_event_rule" {
  name                = "${var.RESOURCE_PREFIX}-nlb-alb-connector-lambda"
  description         = "Fires ${var.LAMBDA_FUNCTION_NAME}"
  schedule_expression = "rate(1 minute)"
}

resource "aws_lambda_permission" "trigger_nlb_alb_connector_permissions" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.LAMBDA_FUNCTION_NAME
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger_nlb_alb_connector_event_rule.arn
}

resource "aws_cloudwatch_event_target" "trigger_nlb_alb_connector_target" {
  rule      = aws_cloudwatch_event_rule.trigger_nlb_alb_connector_event_rule.name
  target_id = var.LAMBDA_FUNCTION_NAME
  arn       = var.LAMBDA_FUNCTION_ARN
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  count = var.ENABLE_VPC_FLOW_LOGS_IN_CLOUDWATCH ? 1 : 0
  name  = "${var.RESOURCE_PREFIX}-${var.CURRENT_ACCOUNT_ID}-logs"
  # kms_key_id = var.KMS_KEY_ARN
}