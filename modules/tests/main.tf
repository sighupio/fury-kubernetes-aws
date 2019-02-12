module "test-aws-vpc" {
  source         = "../aws-vpc"
  name           = "omega"
  env            = "staging"
  ssh-public-key = "fixtures/terraform.pub"
}
