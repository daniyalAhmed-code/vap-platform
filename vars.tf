variable "ENV" {}
variable "EMAIL_ENDPOINT" {}
variable "ENABLE_FEEDBACK_SUBMISSION" {}

variable "DEPLOY_ROLE" {}

variable "CIDR_BLOCK" {}

variable "PRIVATE_SUBNETS" {}
variable "PUBLIC_SUBNETS" {}

variable "ENABLE_VPC_FLOW_LOGS_IN_CLOUDWATCH" {}
variable "ENABLE_VPC_FLOW_LOGS_IN_BUCKET" {}

variable "kms_deletion_windows_in_days" {
  type        = number
  description = "Duration in days after which the key is deleted after destruction of the resource"
  default     = 30
}

variable "create_regional_waf" {
  description = "Create the regional WAF"
  type        = bool
  default     = false
}
variable "create_global_waf" {
  description = "Create the global WAF"
  type        = bool
  default     = false
}
variable "ENABLE_POINT_IN_TIME_RECOVERY" {}
variable "S3_LOGGING_BUCKET" {}
# variable "TRUSTED_ROLE_ACTIONS" {}
variable "layer_compatible_runtimes" {
  type        = list(string)
  description = "List of Runtimes this layer is compatible with"
  default     = ["python3.8"]
}
variable "lambda_runtime" {
  type        = string
  description = "Lambda Runtime"
  default     = "python3.8"
}
variable "logs_retention_days" {
  type    = number
  default = 30
}
variable "secrets_recovery_window_in_days" {
  description = " (Optional) Specifies the number of days that AWS Secrets Manager waits before it can delete the secret. This value can be 0 to force deletion without recovery or range from 7 to 30 days. The default value is 30"
  type        = number
  default     = 30
}

variable "region" {
  type    = string
  default = "us-east-2"
}