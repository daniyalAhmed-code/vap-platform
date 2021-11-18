variable "name" {
  description = "Name of the Web ACL"
}

variable "create" {
  description = "Create WAF"
  type        = bool
  default     = false
}

variable "is_regional" {
  default     = true
  description = "Define WEB to be regional"
}
