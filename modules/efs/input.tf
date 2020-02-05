variable name {
  type        = "string"
  description = "Cluster name"
}

variable env {
  type        = "string"
  description = "Cluster environment"
}

variable "vpc_id" {
  type = "string"
  description = "VPC id where EFS should be created"
}

variable subnets {
  type        = "list"
  description = "List of AWS subnet IDs"
}

variable "allowed_cidr" {
  type = "string"
  default = "0.0.0.0/0"
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}
