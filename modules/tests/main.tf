module "test-aws-vpc" {
  source = "../aws-vpc"
  name   = "omega"
  env    = "staging"

  ssh-public-keys = [
    "${file("fixtures/terraform.pub")}",
  ]
}
