variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID (required only when use_external_dns is false)"
  default     = null
  
  validation {
    condition = var.use_external_dns || var.hosted_zone_id != null
    error_message = "hosted_zone_id is required when use_external_dns is false."
  }
}

variable "use_external_dns" {
  type        = bool
  description = "Set to true when domain is managed outside of AWS (e.g., Cloudflare). When true, hosted_zone_id is not required and Route 53 resources are not created."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to resources"
  default     = {}
}