variable "subdomain" {
  type        = string
  description = "The subdomain the website is available at"
}

variable "environment" {
  type        = string
  description = "The environment for created resources"
}

variable "manage_dns" {
  type        = bool
  description = "True to manage website DNS records (default), false otherwise"
  default     = true
}

variable "allow_dns_overwrite" {
  type        = bool
  description = "True to allow existing DNS records to be overwritten, false otherwise (default)"
  default     = false
}
