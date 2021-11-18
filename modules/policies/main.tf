resource "aws_iam_policy" "vap_policy" {
  name        = "${var.RESOURCE_PREFIX}-flow-logs-policy"
  description = "policy for flow logs"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.RESOURCE_PREFIX}-nlb-alb-connector-lambda-policy"
  description = "policy which is required for nlb to alb connector lambda"

  // to check of createbucket nodig is?
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "LambdaLogging",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "arn:aws:logs:${var.AWS_REGION}:${var.CURRENT_ACCOUNT_ID}:*"
      },
      {
        "Sid" : "S3Objects",
        "Action" : [
          "s3:Get*",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${var.IP_LIST_BUCKET}/*",
          "${var.IP_LIST_BUCKET}"
        ]
      },
      {
        "Sid" : "S3List",
        "Action" : [
          "s3:ListBucket"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${var.IP_LIST_BUCKET}/*",
          "${var.IP_LIST_BUCKET}"
        ]
      },
      {
        "Sid" : "S3ListAll",
        "Action" : [
          "s3:ListAllMyBuckets"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:s3:::*"
      },
      {
        "Sid" : "ELB",
        "Action" : [
          "elasticloadbalancing:Describe*",
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "ELBTG",
        "Action" : [
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        "Effect" : "Allow",
        "Resource" : "${var.NLB_TARGET_ARN}"
      },
      {
        "Sid" : "CW",
        "Action" : [
          "cloudwatch:putMetricData"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = var.LAMBDA_ROLE_NAME
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role_policy_attachment" "flow_logs_role_policy_attachment" {
  role       = var.FLOW_LOGS_ROLE_NAME
  policy_arn = aws_iam_policy.vap_policy.arn
}




data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    actions = ["kms:*"]
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.CURRENT_ACCOUNT_ID}:root"]
    }
    resources = ["*"]
  }

  statement {
      actions = ["kms:Decrypt","kms:Encrypt"]
      effect = "Allow"
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      resources = ["*"]
  }
}