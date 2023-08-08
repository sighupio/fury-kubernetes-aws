terraform {
  required_version = "~> 1.4"
  required_providers {
    local    = "~> 2.4.0"
    null     = "~> 3.2.1"
    aws      = "~> 4.67.0"
    external = "~> 2.3.1"
  }
}

module "addons" {
  source = "../../../fury-kubernetes-aws/modules/eks-addons"
  cluster_name = var.cluster_name
  ebs_csi_driver = {
    enabled = true
    version = "v1.21.0-eksbuild.1"
    configuration_values = file("ebs.json")
  }
  coredns = {
    enabled = true
    version = "v1.9.3-eksbuild.5"
    configuration_values = file("coredns.json")
  }
  kube_proxy = {
    enabled = true
    version = "v1.25.6-eksbuild.1"
    configuration_values = file("kube-proxy.json")
  }
  vpc_cni = {
    enabled = true
    version = "v1.12.2-eksbuild.1"
    configuration_values = file("vpc-cni.json")
  }
}
