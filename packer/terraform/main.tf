terraform {
  backend "s3" {
    bucket = "sighup-fury-dev"
    key    = "fury-kubernetes-aws-feature-auto-join"
    region = "eu-west-1"
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

resource "aws_route" "gw" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}


resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Usage = "packer_build"
  }
}

variable "kinds" {
  default = ["Worker", "Master", "Bastion", "Infra"]
}

variable "user" {
  default = "ubuntu"
}

data "template_file" "builders" {
  count    = length(var.kinds)
  template = file("builders.tpl")
  vars = {
    vpc_id = aws_vpc.main.id
    user   = var.user
    kind   = var.kinds[count.index]
  }
}

data "template_file" "provisioners" {
  count    = length(var.kinds)
  template = file("provisioners.tpl")
  vars = {
    kind = var.kinds[count.index]
  }
}

data "template_file" "amis" {
  template = file("amis.tpl")
  vars = {
    provisioners = join(", ", data.template_file.provisioners.*.rendered)
    builders     = join(", ", data.template_file.builders.*.rendered)
    user         = var.user
  }
}

output "amis" {
  value = data.template_file.amis.rendered
}
