variable "domain_name" {
  type        = "string"
  description = "The domain name (that could be also a wildcard) for the acm certificate you want to create"
}

variable "sans_with_same_domain" {
  type        = "list"
  description = "The list of additional subject_alternative_names with the same domain"
  default     = []
}

variable "allow_validation_record_overwrite" {
  type        = "string"
  description = "allow record overwrite"
}


variable "validation_ttl" {
  type = "string"
  description = "DNS Record TTL"
  default = "600"
}

