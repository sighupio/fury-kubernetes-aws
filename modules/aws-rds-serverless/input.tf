variable "name" {
  type        = "string"
  description = "RDS cluster name"
}

variable "env" {
  type        = "string"
  description = "RDS cluster environment"
}


variable "suffix" {
  type        = "string"
  description = "RDS cluster suffix on cluster identifier"
}

variable "region" {
  type        = "string"
  default     = "eu-west-1"
  description = "AWS region"
}

variable "rds-user" {
  type        = "string"
  description = "RDS cluster username"
}

variable "rds-password" {
  type        = "string"
  description = "RDS cluster password"
}

variable "rds-engine" {
  type        = "string"
  description = "RDS cluster engine"
  default     = "aurora"
}

variable "rds-engine-mode" {
  type        = "string"
  description = "RDS cluster engine version"
  default     = "serverless"
}

variable "rds-engine-version" {
  type        = "string"
  description = "RDS cluster engine version"
  default     = "5.6.10a"
}

variable "rds-backup-retention" {
  type        = "string"
  default     = 7
  description = "RDS cluster backups retention days"
}

variable "rds-parameter-group-name" {
  type        = "string"
  default     = ""
  description = "RDS cluster parameter group name"
}

variable "rds-parameter" {
  type        = "list"
  default     = []
  description = "RDS parameters list"
}

variable "rds-port" {
  type        = "string"
  description = "RDS cluster clients port"
}

variable "rds-aurora-autopause" {
  type        = "string"
  description = "RDS cluster scaling configuration auto pause"
  default     = "true"
}

variable "rds-aurora-max-capacity" {
  type        = "string"
  description = "RDS cluster scaling configuration max capacity"
  default     = "4"
}

variable "rds-aurora-min-capacity" {
  type        = "string"
  description = "RDS cluster scaling configuration min capacity"
  default     = "2"
}

variable "rds-aurora-seconds-until-auto-pause" {
  type        = "string"
  description = "RDS cluster scaling configuration seconds until auto pause"
  default     = "3600"
}

variable "subnets" {
  type        = "list"
  description = "List of AWS subnet IDs"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_subnet" "main" {
  count = "${length(var.subnets)}"
  id    = "${element(var.subnets, count.index)}"
}

variable "friendly_name" {
  type        = "string"
  description = "Friendly Cname Name"
}

variable "domain_name" {
  type        = "string"
  description = "The domain on which create the friendly name"
  default     = ""
}
