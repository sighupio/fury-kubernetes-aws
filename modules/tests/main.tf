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

  ssh-public-keys = [
    "${file("fixtures/terraform.pub")}",
  ]
}
