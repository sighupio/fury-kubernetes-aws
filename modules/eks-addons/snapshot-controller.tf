/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

locals {
  snapshot_controller_default_configuration_values = {
    "tolerations" : [
      {
        "key" : "CriticalAddonsOnly",
        "operator" : "Exists"
      },
      {
        "effect" : "NoExecute",
        "operator" : "Exists",
        "tolerationSeconds" : 300
      }
    ]
  }
}

resource "aws_eks_addon" "snapshot_controller" {
  cluster_name             = var.cluster_name
  addon_name               = "snapshot-controller"
  addon_version            = data.aws_eks_addon_version.latest_snapshot_controller.version
  resolve_conflicts        = var.snapshot_controller.resolve_conflicts
  service_account_role_arn = var.snapshot_controller.service_account_role_arn
  tags                     = var.tags
  count                    = var.snapshot_controller.enabled ? 1 : 0
  configuration_values     = coalesce(var.snapshot_controller.configuration_values, jsonencode(local.snapshot_controller_default_configuration_values))
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

data "aws_eks_addon_version" "latest_snapshot_controller" {
  addon_name         = "snapshot-controller"
  kubernetes_version = data.aws_eks_cluster.eks.version
  most_recent        = true
}