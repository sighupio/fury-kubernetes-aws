provider "aws" {
  region  = "${var.aws_region}"
  version = "1.60.0"
}

variable name {
  default = "fury"
}

variable aws_region {
  default = "eu-west-1"
}


variable env {
  default = "test"
}

variable ssh-public-key {
  default = "../secrets/ssh-user.pub"
}

variable ssh-private-key {
  default = "../secrets/ssh-user"
}

variable "az-count" {
  type        = "string"
  description = "Number of az to deploy the VPC in"
  default     = 3
}

variable "vpc_cidr" {
  type        = "string"
  description = "vpc cidr"
  default     = "10.100.0.0/16"
}

module "vpc" {
  source        = "../modules/aws/aws-vpc"
  name          = "${var.name}"
  env           = "${var.env}"
  vpc-cidr      = "${var.vpc_cidr}"
  region        = "${var.aws_region}"
  internal-zone = "theoutplay.com"
  bastion-ami   = ""

  ssh-public-keys = [
    "${file(var.ssh-public-key)}",
  ]
}

module "k8s" {
  source               = "../vendor/modules/aws/aws-kubernetes"
  region               = "${var.aws_region}"
  name                 = "${var.name}"
  env                  = "${var.env}"
  kube-ami             = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20190531"
  kube-master-count    = "${var.az-count}"
  kube-master-type     = "m5.large"
  kube-private-subnets = "${module.vpc.private_subnets}"
  kube-public-subnets  = "${module.vpc.public_subnets}"
  kube-domain          = "${module.vpc.domain_zone}"
  kube-bastions        = "${module.vpc.bastion_public_ip}"
  ssh-private-key      = "${var.ssh-private-key}"

  kube-lb-internal-domains = [
    "grafana",
    "prometheus",
    "alertmanager",
    "kibana",
    "cerebro",
    "directory",

    "registry",
    "jenkins",

    "apiman-manager.prod",
    "apiman-gateway.prod",
    "rabbit.prod",
    "file-processor.prod",
    "feed-processor.prod",
    "user-backoffice.prod",
    "scheduler.prod",
    "clip-archiver.prod",
  ]

  kube-lb-external-enable-access-log = false

  kube-lb-external-domains = [
    "*.theoutplay.com",
  ]

  kube-workers = [
    {
      kind  = "infra"
      count = 3
      type  = "t3.xlarge"
    },
    {
      kind  = "prod"
      count = 6
      type  = "t3.large"
    },
    # {
    #   kind  = "mem-prod"
    #   count = 2
    #   type  = "r5a.large"
    # },
  ]

  ecr-repositories = []

  kube-workers-security-group = [
    {
      type        = "ingress"
      to_port     = 32080
      from_port   = 32080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ssh-public-keys = [
    "${file(var.ssh-public-key)}",
  ]
}

module "dev-furyagent" {
  source                = "../vendor/modules/aws/s3-furyagent"
  cluster_name          = "${var.name}"
  environment           = "${var.env}"
  aws_region            = "${var.aws_region}"
  furyagent_bucket_name = "top-${var.name}-${var.env}-agent"
}

module "dev-aws-ark" {
  source                 = "../vendor/modules/dr/aws-ark"
  cluster_name           = "${var.name}"
  environment            = "${var.env}"
  aws_region             = "${var.aws_region}"
  ark_backup_bucket_name = "${var.name}-${var.env}-ark"
}

module "es-managed-dev" {
  providers = {
    "aws" = "aws"
  }
  source = "elasticsearch-managed"
  # name = "${var.name}"
  name                     = "top"
  env                      = "dev"
  domain                   = "events-es"
  instance_type            = "t2.medium.elasticsearch"
  elasticsearch_version    = "6.7"
  instance_count           = 1
  volume_size              = 35
  dedicated_master_enabled = false
  # dedicated_master_type = "t2.medium.elasticsearch"
  # dedicated_master_count = 3
  automated_snapshot_start_hour = 23
}
