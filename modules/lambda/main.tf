

################
#### Lambda ####
################
resource "aws_lambda_function" "lambda" {
  filename      = "${path.module}/zip/nlb_alb_connector_lambda.zip"
  function_name = "${var.RESOURCE_PREFIX}-nlb-alb-connector-lambda"
  role          = var.LAMBDA_ROLE_ARN
  handler       = "nlb_alb_connector_lambda.lambda_handler"

  source_code_hash = "${data.archive_file.nlb_alb_connector_lambda_function.output_base64sha256}"

  runtime = "python3.8"
  timeout = 300

  environment {
    variables = {
      ALB_DNS_NAME                      = var.ALB_DNS_NAME
      ALB_LISTENER                      = "${var.ALB_LISTENER}"
      INVOCATIONS_BEFORE_DEREGISTRATION = 3
      MAX_LOOKUP_PER_INVOCATION         = 50
      NLB_TG_ARN                        = var.NLB_TARGET_ARN
      S3_BUCKET                         = var.IP_LIST_BUCKET_ID
      CW_METRIC_FLAG_IP_COUNT           = true
    }
  }
}
