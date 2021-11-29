module "api_project" {
  source = "./vendor/modules/api"
  # stage_name   = var.env
  stage_name = "beta"
  #name         = "${var.name}-${var.env}-device-type"
  name           = "Project"
  description    = "API for Activity Outbound Resource"
  swagger_file   = "./templates/swagger-Project-1.0.0.yaml"
  common_swagger = "./templates/common.yaml"
  # waf_acl_id     = data.terraform_remote_state.infra.outputs.regional_waf_id
    waf_acl_id       = ""

  swagger_vars = {
    REGION                 = data.aws_region.current.name
    DEVICE_TYPE_LAMBDA_ARN = module.device_type_lambda.lambda_function_arn
    EXECUTION_ROLE_ARN     = module.lambda_execution_role.iam_role_arn
    AUTHORIZER_LAMBDA_URI  = "arn:aws:apigateway:us-east-2:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-2:489994096722:function:vap-dani-s-test-api-key-authoriser/invocations"
  }
  add_lambda_permission = false
  domain_name           = "dani.groveops.net"
  base_path             = "project"
}
