variable "name" {
  type        = "string"
  description = "RDS cluster name"
}

variable "env" {
  type        = "string"
  description = "RDS cluster environment"
}

variable "region" {
  type        = "string"
  default     = "eu-west-1"
  description = "AWS region"
}

variable "rds-nodes-count" {
  type        = "string"
  default     = 1
  description = "RDS cluster nodes count"
}

variable "rds-nodes-type" {
  type        = "string"
  default     = "db.t2.small"
  description = "RDS cluster nodes type"
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
}

variable "rds-engine-version" {
  type        = "string"
  description = "RDS cluster engine version"
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

variable "rds-parameter-group-family" {
  type        = "string"
  description = "RDS cluster parameter group family"
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

variable "subnets" {
  type        = "list"
  description = "List of AWS subnet IDs"
}

data "aws_subnet" "main" {
  count = "${length(var.subnets)}"
  id    = "${element(var.subnets, count.index)}"
}
