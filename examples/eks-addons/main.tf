/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

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
  source = "../../modules/eks-addons"
  cluster_name = var.cluster_name
  ebs_csi_driver = {
    enabled = true
    version = "v1.40.1-eksbuild.1"
    configuration_values = file("ebs.json")
  }
  snapshot_controller = {
    enabled = true
    version = "v8.2.0-eksbuild.1"
    configuration_values = file("snapshot-controller.json")
  }
  coredns = {
    enabled = true
    version = "v1.11.4-eksbuild.2"
    configuration_values = file("coredns.json")
  }
  kube_proxy = {
    enabled = true
    version = "v1.31.3-eksbuild.2"
    configuration_values = file("kube-proxy.json")
  }
  vpc_cni = {
    enabled = true
    version = "v1.19.3-eksbuild.1"
    configuration_values = file("vpc-cni.json")
  }
}
