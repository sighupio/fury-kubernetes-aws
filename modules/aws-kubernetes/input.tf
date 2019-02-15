variable name {
  type        = "string"
  description = "Cluster name"
}

variable env {
  description = "Cluster environment"
}

# REMOVE IT!!!!
variable ssh_private_key {
  default = "ABC"
}

variable region {
  type        = "string"
  default     = "eu-west-1"
  description = "AWS region"
}

variable kube-master-count {
  type        = "string"
  default     = 1
  description = "Number of Kubernetes master nodes"
}

variable kube-master-type {
  type        = "string"
  default     = "t3.medium"
  description = "Kubernetes master nodes EC2 instance type"
}

variable kube-master-volumes {
  type        = "list"
  default     = []
  description = "Kubernetes master nodes volumes"
}

# kube-master-volumes = [
#   {
#     size = 10,
#     type = gp2,
#     iops = ...,
#     device_name = /dev/sdf
#   }
# ]

variable kube-workers {
  type        = "list"
  description = "List of maps holding definition of Kubernetes workers"
}

# kube-workers = [
#   {
#     kind = "infra"
#     count = 2
#     type = "m5.large"
#   },
#   {
#     kind = "production"
#     count = 3
#     type = "c5.large"
#   },
# ]

variable kube-ami {
  type        = "string"
  default     = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  description = "Kubernetes nodes AMI"
}

variable kube-lb-external-type {
  type        = "string"
  default     = "application"
  description = "Kubernetes external loadbalancer type"
}

variable kube-lb-external-domains {
  type        = "list"
  default     = []
  description = "TLS certificates domains"
}

variable kube-master-security-group {
  type        = "list"
  default     = []
  description = "Kubernetes master security group rules"
}

variable kube-workers-security-group {
  type        = "list"
  default     = []
  description = "Kubernetes workers security group rules"
}

# kube-master-security-group = [
#   {
#     type = "ingress|engress",
#     to_port = ...,
#     from_port = ...,
#     protocol = ...,
#     cidr_blocks = ...,
#   }
# ]

variable kube-private-subnets {
  type        = "list"
  description = "List of AWS private subnet IDs"
}

variable kube-public-subnets {
  type        = "list"
  description = "List of AWS public subnet IDs"
}

variable kube-domain {
  type        = "string"
  description = "Route53 zone ID"
}

variable ssh-public-keys {
  type        = "list"
  description = "List of public SSH keys authorized to connect to Kubernetes nodes"
}

provider aws {
  region = "${var.region}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.kube-ami}"]
  }
}

data "aws_subnet" "private" {
  count = "${length(var.kube-private-subnets)}"
  id    = "${element(var.kube-private-subnets, count.index)}"}

data "aws_subnet" "public" {
  count = "${length(var.kube-public-subnets)}"
  id    = "${element(var.kube-public-subnets, count.index)}"
}

variable bastion-public-ip {
  type = "list"
} 

