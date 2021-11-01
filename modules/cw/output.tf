output "VPC_FLOW_LOGS_CLOUDWATCH" {
  value = length(aws_cloudwatch_log_group.vpc_flow_logs) > 0 ? aws_cloudwatch_log_group.vpc_flow_logs[0].arn : ""
}