resource "aws_iam_role" "flow_logs_role" {
  name = "${var.RESOURCE_PREFIX}-flow-logs-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.RESOURCE_PREFIX}-nlb-alb-connector-lambda-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
# resource "aws_iam_role" "vpc_config_lambda_role" {
#   count = var.create_role ? 1 : 0

#   name                 = "${var.RESOURCE_PREFIX}--apigateway-lambda-execution-role"
#   description          = var.role_description

#   force_detach_policies = var.force_detach_policies
#   permissions_boundary  = var.role_permissions_boundary_arn

#   assume_role_policy = var.role_requires_mfa ? data.aws_iam_policy_document.assume_role_with_mfa.json : data.aws_iam_policy_document.assume_role.json

#   tags = var.tags
# }
