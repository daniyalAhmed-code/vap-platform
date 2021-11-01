

variable "ALB_DNS_NAME" {
  description = "DNS of ALB"
  type        = string
}

variable "ALB_LISTENER" {
  description = "Port of ALB"
  type        = number
}

variable "NLB_TARGET_ARN" {
  description = "Target ARN of NLB"
  type        = string
}

variable "RESOURCE_PREFIX" {}
variable "LAMBDA_ROLE_ARN" {}
variable "IP_LIST_BUCKET_ID" {}
