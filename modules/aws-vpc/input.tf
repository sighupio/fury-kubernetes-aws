variable "vpc-cidr" {
  type    = "string"
  default = "10.10.0.0/16"
}

variable "az-count" {
  type        = "string"
  description = "Number of az to deploy the VPC in"
  default     = 3
}

variable "bastion-vpn-enable" {
  type    = "string"
  default = true
}

variable "bastion-ssh-enable" {
  type    = "string"
  default = true
}

variable "name" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "region" {
  type    = "string"
  default = "eu-west-1"
}

variable "internal-zone" {
  type        = "string"
  description = "Domain name for internal services"
}

variable "additional-zone" {
  type        = "string"
  default     = ""
  description = "Additional domain name for internal services"
}

variable "bastion-instance-type" {
  type    = "string"
  default = "t3.small"
}

variable "bastion-count" {
  type    = "string"
  default = 2
}

variable "bastion-ami" {
  type    = "string"
  default = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
}

variable "ssh-public-keys" {
  type        = "list"
  description = "List of public SSH keys authorized to connect to the bastions"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.bastion-ami}"]
  }
}

data "aws_availability_zones" "available" {}
