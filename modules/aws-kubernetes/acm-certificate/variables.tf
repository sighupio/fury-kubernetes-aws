variable "domain_name" {
  type        = "string"
  description = "The domain name (that could be also a wildcard) for the acm certificate you want to create"
}

variable "sans_with_same_domain" {
  type        = "list"
  description = "The list of additional subject_alternative_names with the same domain"
  default     = []
}

variable "public_hosted_zone_id" {
  type        = "string"
  description = "The AWS hosted zone id to be referenced by the records"
}

variable "allow_validation_record_overwrite" {
  type        = "bool"
  description = "allow record overwrite"
}
