variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "domain_name_subdomain" {
  type        = string
  description = "The subdomain name for the website"
  default     = null
}

variable "aliases" {
  type        = list(string)
  description = "The aliases for the website"
  default     = []
}

variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID (required only when use_external_dns is false)"
  default     = null
}

variable "use_external_dns" {
  type        = bool
  description = "Set to true when domain is managed outside of AWS (e.g., Cloudflare). When true, hosted_zone_id is not required and Route 53 resources are not created."
  default     = false
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate to use with CloudFront. Required when use_external_dns is true. Leave empty when using Route 53 (certificate will be created automatically)."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to resources"
  default     = {}
}