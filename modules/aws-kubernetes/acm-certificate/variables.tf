variable "domain_name" {
  type        = "string"
  description = "The domain name (that could be also a wildcard) for the acm certificate you want to create"
}

variable "sans" {
  type        = "list"
  description = "The list of additional subject_alternative_names"
  default     = []
}

variable "hosted_zone_id" {
  type        = "string"
  description = "The AWS hosted zone id to be referenced by the records"
}
