variable "domain_name" {
  type        = string
  description = "The domain name for the website"
}

variable "hosted_zone_id" {
  type        = string
  description = "The Route 53 hosted zone ID"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to resources"
  default     = {}
}
