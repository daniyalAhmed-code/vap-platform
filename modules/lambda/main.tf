

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
  tracing_config {
    mode= "PassThrough"
  }
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

#VAP-CONNECTOR-LAYERS

# resource "aws_lambda_layer_version" "simple_salesforce_lambda_layer" {
#   filename            = "${path.module}/layers/nodejs.zip"
#   layer_name          = "simple-salesforce-lambda-layer"    
#   runtime             = var.lambda_runtime
#   compatible_runtimes = var.layer_compatible_runtimes
#   source_path = {
#   pip_requirements = "lambdas/layers/simple-salesforce/requirements.txt",
#   prefix_in_zip    = "python"
#   }
#   hash_extra      = sha256(file("lambdas/layers/simple-salesforce/requirements.txt"))
# }

# resource "aws_lambda_layer_version" "utils_lambda_layer" {
#   layer_name          = "utils-lambda-layer"
#   description         = "Lambda layer with some util modules"
#   compatible_runtimes = var.layer_compatible_runtimes
#   source_path = {
#     path             = "${path.module}/lambdas/layers/utils",
#     pip_requirements = false
#     prefix_in_zip    = "python/utils"
#   }
# }

#VAP-CONNECTOR-LAMBDAS


# resource "aws_lambda_function" "lambda_catalog_updater_lambda_function" {
#   provider            = aws.src
#   filename         = "${path.module}/zip/catalog-updater.zip"
#   function_name    = "${var.RESOURCE_PREFIX}-catalog-updater"
#   role             = "${var.LAMBDA_CATALOG_UPDATER_ROLE_ARN}"
#   handler          = "index.handler"
#   source_code_hash = "${data.archive_file.lambda_catalog_updater_lambda_function.output_base64sha256}"
#   runtime          = "nodejs12.x"
#   timeout          = "20"
#   layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]

#   environment {
#     variables = {
#       "BucketName" = "${var.ARTIFACTS_S3_BUCKET_NAME}"
#     }
#   }
# }

# resource "aws_lambda_function" "lambda_catalog_updater_lambda_function" {
#   provider            = aws.src
#   filename         = "${path.module}/zip/catalog-updater.zip"
#   function_name    = "${var.RESOURCE_PREFIX}-catalog-updater"
#   role             = "${var.LAMBDA_CATALOG_UPDATER_ROLE_ARN}"
#   handler          = "index.handler"
#   source_code_hash = "${data.archive_file.lambda_catalog_updater_lambda_function.output_base64sha256}"
#   runtime          = "nodejs12.x"
#   timeout          = "20"
#   layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]

#   environment {
#     variables = {
#       "BucketName" = "${var.ARTIFACTS_S3_BUCKET_NAME}"
#     }
#   }
# }

# resource "aws_lambda_function" "lambda_catalog_updater_lambda_function" {
#   provider            = aws.src
#   filename         = "${path.module}/zip/catalog-updater.zip"
#   function_name    = "${var.RESOURCE_PREFIX}-catalog-updater"
#   role             = "${var.LAMBDA_CATALOG_UPDATER_ROLE_ARN}"
#   handler          = "index.handler"
#   source_code_hash = "${data.archive_file.lambda_catalog_updater_lambda_function.output_base64sha256}"
#   runtime          = "nodejs12.x"
#   timeout          = "20"
#   layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]

#   environment {
#     variables = {
#       "BucketName" = "${var.ARTIFACTS_S3_BUCKET_NAME}"
#     }
#   }
# }

# resource "aws_lambda_function" "lambda_catalog_updater_lambda_function" {
#   provider            = aws.src
#   filename         = "${path.module}/zip/catalog-updater.zip"
#   function_name    = "${var.RESOURCE_PREFIX}-catalog-updater"
#   role             = "${var.LAMBDA_CATALOG_UPDATER_ROLE_ARN}"
#   handler          = "index.handler"
#   source_code_hash = "${data.archive_file.lambda_catalog_updater_lambda_function.output_base64sha256}"
#   runtime          = "nodejs12.x"
#   timeout          = "20"
#   layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]

#   environment {
#     variables = {
#       "BucketName" = "${var.ARTIFACTS_S3_BUCKET_NAME}"
#     }
#   }
# }

# resource "aws_lambda_function" "lambda_catalog_updater_lambda_function" {
#   provider            = aws.src
#   filename         = "${path.module}/zip/catalog-updater.zip"
#   function_name    = "${var.RESOURCE_PREFIX}-catalog-updater"
#   role             = "${var.LAMBDA_CATALOG_UPDATER_ROLE_ARN}"
#   handler          = "index.handler"
#   source_code_hash = "${data.archive_file.lambda_catalog_updater_lambda_function.output_base64sha256}"
#   runtime          = "nodejs12.x"
#   timeout          = "20"
#   layers           = ["${aws_lambda_layer_version.lambda-common-layer.arn}"]

#   environment {
#     variables = {
#       "BucketName" = "${var.ARTIFACTS_S3_BUCKET_NAME}"
#     }
#   }
# }