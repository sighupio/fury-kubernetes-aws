terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sighupio"

    workspaces {
      name = "fury-kubernetes-aws"
    }
  }
}

variable "region" {
  default = "eu-west-1"
}

provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Usage = "packer_build"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Usage = "packer_build"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Usage = "packer_build"
  }
}

output "packer" {
  value = <<EOF
{
  "variables": {
    "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
    "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}"
  },
  "builders": [{
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "${var.region}",
    "subnet_filter": {
      "filters": {
        "tag:Usage": "packer_build"
      },
      "most_free": true,
      "random": false
    }
    "vpc_id": "${aws_vpc.main.id}",
    "instance_type": "t2.micro",
    "source_ami_filter": {
      "filters": {
        "virtualization-type": "hvm",
        "name": "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*",
        "root-device-type": "ebs"
      },
      "owners": ["099720109477"],
      "most_recent": true
    },
    "ssh_username": "ubuntu",
    "ami_name": "KFD-Ubuntu-{{timestamp}}"
  }]
}
EOF
}
