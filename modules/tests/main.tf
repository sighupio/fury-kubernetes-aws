module "test-aws-vpc" {
  source = "../aws-vpc"
  name   = "omega"
  env    = "staging"

  ssh-public-keys = [
    "${file("fixtures/terraform.pub")}",
  ]
}

module "test-aws-kubernetes" {
  source            = "../aws-kubernetes"
  name              = "omega"
  env               = "staging"
  kube-master-count = 3
  kube-master-type  = "t3.small"

  # kube-master-volumes = [
  #   {
  #     size = 10,
  #     type = "gp2",
  #     iops = 0,
  #     device_name = "/dev/sdf"
  #   },
  #   # {
  #   #   size = 15,
  #   #   type = "io1",
  #   #   iops = 100,
  #   #   device_name = "/dev/sdg",
  #   # },
  #   # {
  #   #   size = 10,
  #   #   type = "standard",
  #   #   iops = 0,
  #   #   device_name = "/dev/sdh",
  #   # }
  # ]

  kube-workers = [
    {
      kind  = "infra"
      count = 2
      type  = "t3.small"
    },
    {
      kind  = "production"
      count = 2
      type  = "t3.small"
    },
    {
      kind  = "staging"
      count = 1
      type  = "t3.small"
    },
  ]

  kube-private-subnets = "${module.test-aws-vpc.private_subnets}"
  kube-public-subnets  = "${module.test-aws-vpc.public_subnets}"
  kube-domain          = "${module.test-aws-vpc.domain_zone}"

  kube-master-security-group = [
    {
      type = "ingress",
      to_port = 8060
      from_port = 8060
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type = "ingress",
      to_port = 8070
      from_port = 8070
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type = "ingress",
      to_port = 8080
      from_port = 8080
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  kube-workers-security-group = [
    {
      type = "ingress",
      to_port = 9060
      from_port = 9060
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type = "ingress",
      to_port = 9070
      from_port = 9070
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      type = "ingress",
      to_port = 9080
      from_port = 9080
      protocol = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ssh-public-keys = [
    "${file("fixtures/terraform.pub")}",
  ]
}
