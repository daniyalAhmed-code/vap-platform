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
variable "ENABLE_POINT_IN_TIME_RECOVERY" {}