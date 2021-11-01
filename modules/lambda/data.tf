data "archive_file" "nlb_alb_connector_lambda_function" {
  type        = "zip"
  source_dir  = "${path.module}/code/nlb_alb_connector_lambda"
  output_path = "${path.module}/zip/nlb_alb_connector_lambda.zip"
}
