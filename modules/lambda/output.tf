output "NLB_ALB_CONNECTOR_LAMBDA_ARN" {
  description = "The ID of the lambda"
  value       = aws_lambda_function.lambda.arn
}

output "NLB_ALB_CONNECTOR_LAMBDA_NAME" {
  description = "The ARN of the lambda"
  value       = aws_lambda_function.lambda.function_name
}

