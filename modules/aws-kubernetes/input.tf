variable name {
  type        = "string"
  description = "Cluster name"
}

variable env {
  type        = "string"
  description = "Cluster environment"
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
#     min = 3
#     desired = 3
#     max = 3
#     type = "m5.large"
#     kube-ami= "KFD-Ubuntu-Infra-1571399626"
#   },
#   {
#     kind = "production"
#     min = 2
#     desired = 2
#     max = 2
#     type = "c5.large"
#     kube-ami= "KFD-Ubuntu-Worker-1571399626"
#   },
# ]

variable kube-workers-spot {
  type        = "list"
  description = "List of maps holding definition of Kubernetes workers spot"
}

# kube-workers-spot = [
#   {
#     kind = "job"
#     min = 2
#     desired = 2
#     max = 2
#     type = "m5.large"
#     kube-ami= "KFD-Ubuntu-Infra-1571399626"
#   },
#   {
#     kind = "stateless"
#     min = 2
#     desired = 2
#     max = 2
#     type = "c5.large"
#     kube-ami= "KFD-Ubuntu-Worker-1571399626"
#   },
# ]

variable "kube-workers-ami-owner" {
  type        = "string"
  default     = "363601582189"
  description = "Kubernetes workers AMI Owner"
}

variable kube-master-ami {
  type        = "string"
  default     = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
  description = "Kubernetes nodes AMI"
}

variable "kube-master-ami-owner" {
  type        = "string"
  default     = "099720109477"
  description = "Kubernetes nodes AMI Owner"
}

variable kube-lb-internal-domains {
  type        = "list"
  default     = []
  description = "List of domains to be created for internal loadbalancer on Kubernetes DNS zone"
}

variable kube-lb-internal-additional-domains {
  type        = "list"
  default     = []
  description = "List of domains to be created for internal loadbalancer on additional DNS zone"
}

variable kube-lb-external-domains {
  type        = "list"
  default     = []
  description = "List of domains for TLS termination on external loadbalancer"
}

variable kube-lb-external-enable-access-log {
  type        = "string"
  default     = false
  description = "Enable access log on external load balancer"
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

variable kube-bastions {
  type        = "list"
  description = "List of bastion public IP addresses"
}

variable kube-domain {
  type        = "string"
  description = "Route53 Kubernetes zone ID"
}

variable additional-domain {
  type        = "string"
  default     = ""
  description = "Route53 additional zone ID"
}

variable ssh-public-keys {
  type        = "list"
  description = "List of public SSH keys authorized to connect to Kubernetes nodes"
}

variable ssh-private-key {
  type        = "string"
  description = "Path to own private key to access machines"
}

variable ecr-repositories {
  type        = "list"
  description = "List of docker image repositories to create"
}

variable s3-bucket-name {
  description = "furyagent auxiliary bucket name"
}

variable join-policy-arn {
  description = "policy granting access to kubeadm generated token to workers"
}

variable "alertmanager-hostname" {
  default     = ""
  description = "Alertmanager hostname used to push cloud-init alerts"
}

data "aws_ami" "master" {
  most_recent = true
  owners      = ["${var.kube-master-ami-owner}"]

  filter {
    name   = "name"
    values = ["${var.kube-master-ami}"]
  }
}

data "aws_ami" "worker" {
  count       = "${length(var.kube-workers)}"
  most_recent = true
  owners      = ["${var.kube-workers-ami-owner}"]

  filter {
    name   = "name"
    values = ["${lookup(var.kube-workers[count.index], "kube-ami")}"]
  }
}

data "aws_ami" "spot" {
  count       = "${length(var.kube-workers-spot)}"
  most_recent = true
  owners      = ["${var.kube-workers-ami-owner}"]

  filter {
    name   = "name"
    values = ["${lookup(var.kube-workers-spot[count.index], "kube-ami")}"]
  }
}

data "aws_subnet" "private" {
  count = "${length(var.kube-private-subnets)}"
  id    = "${element(var.kube-private-subnets, count.index)}"
}

data "aws_subnet" "public" {
  count = "${length(var.kube-public-subnets)}"
  id    = "${element(var.kube-public-subnets, count.index)}"
}

data "aws_vpc" "main" {
  id = "${data.aws_subnet.private.0.vpc_id}"
}

data "aws_route53_zone" "main" {
  zone_id = "${var.kube-domain}"
}

data "aws_route53_zone" "additional" {
  count   = "${var.additional-domain == "" ? 0 : 1}"
  zone_id = "${var.additional-domain}"
}

#node-role.kubernetes.io

variable "node-role-tag-cluster-autoscaler" {
  default = "node-role.kubernetes.io"
  type    = "string"
}

variable "ecr-additional-pull-account-id" {
  default = ""
  type    = "string"
}
