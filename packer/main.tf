terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sighupio"

    workspaces {
      name = "fury-kubernetes-aws"
    }
  }
}

provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Usage = "packer_build"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Main"
  }
}

