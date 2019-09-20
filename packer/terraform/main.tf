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
  default = ["Worker", "Master", "Bastion"]
}

variable "user" {
  default = "ubuntu"
}

data "template_file" "builders" {
  count    = len(var.kinds)
  template = <<EOF
  {
    "name": "${kind}",
    "type": "amazon-ebs",
    "access_key": "{{user `aws_access_key`}}",
    "secret_key": "{{user `aws_secret_key`}}",
    "region": "eu-west-1",
    "subnet_filter": {
      "filters": {
        "tag:Usage": "packer_build"
      },
      "most_free": true,
      "random": false
    },
    "vpc_id": "${vpc_id}",
    "instance_type": "t2.micro",
    "source_ami_filter": {
      "filters": {
        "virtualization-type": "hvm",
        "name": "ubuntu/images/hvm-ssd/ubuntu-xenial-18.04-amd64-server-*",
        "root-device-type": "ebs"
      },
      "owners": ["099720109477"],
      "most_recent": true
    },
    "ssh_username": "${user}",
    "ami_name": "KFD-Ubuntu-${kind}-{{timestamp}}"
  }
  EOF
  vars = {
    vpc_id = aws_vpc.main.id
    user   = var.user
    kind   = var.kinds[count.index]
  }
}

data "template_file" "provisioners" {
  count    = len(var.kinds)
  template = <<EOF
  {
    "type": "ansible",
    "playbook_file": "playbook-${kind}.yaml",
    "only": ["${kind}"]
  }
  EOF
  vars = {
    kind = var.kinds[count.index]
  }
}

data "template_file" "amis" {
  template = <<EOT
  {
    "variables": {
      "aws_access_key": "{{env `AWS_ACCESS_KEY_ID`}}",
      "aws_secret_key": "{{env `AWS_SECRET_ACCESS_KEY`}}"
    },
    "builders": [
      ${builders}
    ],
    "provisioners": [
      ${provisioners},
      {
        "type": "shell",
        "inline": [
          "rm /home/${user}/.ssh/authorized_keys"
        ]
      }

    ]
  }

  EOT
  vars = {
    provisioners = join(", ", template_file.provisioners.*.rendered)
    builders     = join(", ", template_file.provisioners.*.rendered)
  }
}

output "amis" {
  value = template_file.amis.rendered
}
