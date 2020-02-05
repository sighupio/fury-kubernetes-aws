provider "aws" {
  region  = "${var.aws_region}"
  version = "2.46.0"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "furyagent_bucket_name" {
  default = "omega-staging"
}

module "test-aws-vpc" {
  source        = "../aws-vpc"
  name          = "omega"
  env           = "staging"
  vpc-cidr      = "10.100.0.0/16"
  region        = "${var.aws_region}"
  internal-zone = "staging.k8s.example.com"

  ssh-public-keys = [
    "${file("fixtures/terraform.pub")}",
  ]
}

module "test-aws-s3-furyagent" {
  source                = "../s3-furyagent"
  cluster_name          = "omega"
  environment           = "staging"
  aws_region            = "${var.aws_region}"
  furyagent_bucket_name = "${var.furyagent_bucket_name}"
}

module "test-aws-kubernetes" {
  source                = "../aws-kubernetes"
  name                  = "omega"
  env                   = "staging"
  kube-master-ami-owner = "363601582189"
  kube-master-ami       = "KFD-Ubuntu-Master-1.15.5-2-1575471112"
  kube-master-count     = 3
  kube-master-type      = "t3.small"
  kube-private-subnets  = "${module.test-aws-vpc.private_subnets}"
  kube-public-subnets   = "${module.test-aws-vpc.public_subnets}"
  kube-domain           = "${module.test-aws-vpc.domain_zone}"
  kube-bastions         = "${module.test-aws-vpc.bastion_public_ip}"
  s3-bucket-name        = "${var.furyagent_bucket_name}"
  join-policy-arn       = "${module.test-aws-s3-furyagent.bucket_policy_join}"
  alertmanager-hostname = "alertmanager.development.fury.sighup.io"

  kube-lb-internal-domains = [
    "grafana",
    "prometheus",
    "alertmanager",
    "kibana",
    "cerebro",
    "directory",
  ]

  kube-lb-internal-additional-domains = []

  kube-lb-external-enable-access-log = false

  kube-lb-external-domains = []

  kube-master-volumes = [
    {
      size        = 10
      type        = "gp2"
      iops        = 0
      device_name = "/dev/sdf"
    },
    {
      size        = 15
      type        = "io1"
      iops        = 100
      device_name = "/dev/sdg"
    },
    {
      size        = 10
      type        = "standard"
      iops        = 0
      device_name = "/dev/sdh"
    },
  ]

  kube-workers = [
    {
      kind     = "infra"
      count    = 2
      type     = "t3.small"
      kube-ami = "KFD-Ubuntu-Node-1.15.5-2-1575471113"
    },
    {
      kind     = "production"
      count    = 2
      type     = "t3.small"
      kube-ami = "KFD-Ubuntu-Node-1.15.5-2-1575471113"
    },
    {
      kind     = "staging"
      count    = 1
      type     = "t3.small"
      kube-ami = "KFD-Ubuntu-Node-1.15.5-2-1575471113"
    },
  ]

  ecr-repositories = []

  kube-master-security-group = [
    {
      type        = "ingress"
      to_port     = 8060
      from_port   = 8060
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      to_port     = 8070
      from_port   = 8070
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      to_port     = 8080
      from_port   = 8080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  kube-workers-security-group = [
    {
      type        = "ingress"
      to_port     = 9060
      from_port   = 9060
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      to_port     = 9070
      from_port   = 9070
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type        = "ingress"
      to_port     = 32080
      from_port   = 32080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ssh-public-keys = [
    "${file("fixtures/terraform.pub")}",
  ]

  ssh-private-key = "fixitures/terraform"
}

module "test-rds" {
  source                     = "../aws-rds"
  name                       = "omega"
  env                        = "staging"
  region                     = "${var.aws_region}"
  rds-nodes-count            = 1
  rds-nodes-type             = "db.r4.xlarge"
  rds-user                   = "test"
  rds-password               = "asfdfsljfsla1239enkcvslkjd"
  rds-engine                 = "aurora-postgresql"
  rds-engine-version         = 10.7
  rds-backup-retention       = 30
  rds-parameter-group-family = "aurora-postgresql10"

  rds-parameter = [
    {
      name  = "rds.log_retention_period"
      value = "10080"
    },
    {
      name  = "pgaudit.log"
      value = "all"
    },
    {
      name  = "pgaudit.log_parameter"
      value = "1"
    },
    {
      name  = "pgaudit.log_level"
      value = "info"
    },
    {
      name  = "pgaudit.role"
      value = "rds_pgaudit"
    },
    {
      name         = "shared_preload_libraries"
      value        = "pgaudit,pg_stat_statements"
      apply_method = "pending-reboot"
    },
  ]

  rds-port = 5432
  subnets  = "${module.test-aws-vpc.private_subnets}"
}
