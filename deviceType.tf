#### Lambda ####
module "device_type_lambda" {
  source                   = "./vendor/lambda"
  function_name            = "device-type-lambda"
  description              = "Lambda to Site Tracket Device Type"
  handler                  = "index.lambda_handler"
  runtime                  = var.lambda_runtime
  source_path              = "${path.module}/lambdas/functions/device_type"
  recreate_missing_package = false
  ignore_source_code_hash  = true
  build_in_docker          = true
  docker_image             = "public.ecr.aws/j9c7g0r1/lambda_python:latest"
  docker_pip_cache         = true
  memory_size              = 1024
  timeout                  = 30
  layers = [
    module.simple_salesforce_lambda_layer.lambda_layer_arn,
    module.utils_lambda_layer.lambda_layer_arn,
  ]
  environment_variables = {
    SITETRACKER_USER_TABLE = module.dynamodb.DEV_PORTAL_CUSTOMERS_TABLE_NAME
    KMS_KEY_ID             = module.kms.key_id
  }
  vpc_security_group_ids = [module.vpc.SG_ID, module.VPC.LAMBDA_VPC_COMMUNICATION]
  vpc_subnet_ids         = module.vpc.private_subnet
  cloudwatch_logs_retention_in_days = var.logs_retention_days
  attach_policy_json                = true
  policy_json                       = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": ["${module.vdp_pt_secret.arn}"]
        },
        {
          "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem"
            ],
            "Resource": ["${module.dynamodb.DEV_PORTAL_CUSTOMERS_TABLE_ARN}"]

        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey"
            ],
            "Resource": ["${module.kms.key_arn}"],
            "Condition": {
              "StringEquals": {
                "kms:ViaService": [
                  "secretsmanager.${var.region}.amazonaws.com"
                ]
              }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
              "ec2:DescribeNetworkInterfaces",
              "ec2:CreateNetworkInterface",
              "ec2:DeleteNetworkInterface",
              "ec2:DescribeInstances",
              "ec2:AttachNetworkInterface"
            ],
            "Resource": "*"
          },
        {
    "Effect": "Allow",
    "Action": [
        "kms:Decrypt",
        "kms:Encrypt"
    ],
    "Resource": [
        "*"
    ]
    }     
    ]
}
EOF
}

#### API ####
module "api_device_type" {
  source = "./vendor/modules/api"
  # stage_name   = var.env
  stage_name = "beta"
  #name         = "${var.name}-${var.env}-device-type"
  name           = "DeviceType"
  description    = "API for Site Tracker to Device Type Resource"
  swagger_file   = "./templates/deviceType.yaml"
  common_swagger = "./templates/common.yaml"
  # waf_acl_id     = data.terraform_remote_state.infra.outputs.regional_waf_id
    waf_acl_id       = ""

  swagger_vars = {
    REGION                 = data.aws_region.current.name
    DEVICE_TYPE_LAMBDA_ARN = module.device_type_lambda.lambda_function_arn
    EXECUTION_ROLE_ARN     = module.lambda_execution_role.iam_role_arn
    AUTHORIZER_LAMBDA_URI  = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:489994096722:function:vap-dani-s-test-api-key-authoriser/invocations"
  }
  add_lambda_permission = true
  lambda_functions_names = [
    module.device_type_lambda.lambda_function_name
  ]
  domain_name = "dani.groveops.net"
  base_path   = "deviceType"
}

