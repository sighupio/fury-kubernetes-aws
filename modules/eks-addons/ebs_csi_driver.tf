/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = data.aws_eks_addon_version.latest_ebs_csi_driver.version
  resolve_conflicts        = var.ebs_csi_driver.resolve_conflicts
  service_account_role_arn = var.ebs_csi_driver.service_account_role_arn
  tags                     = var.tags
  count                    = var.ebs_csi_driver.enabled ? 1 : 0
  configuration_values     = var.ebs_csi_driver.configuration_values != null ? var.ebs_csi_driver.configuration_values : <<EOF
{
  "controller": {
    "tolerations": [
      {
        "operator": "Exists"
      }
    ]
  }
}
EOF
  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}

data "aws_eks_addon_version" "latest_ebs_csi_driver" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = data.aws_eks_cluster.eks.version
  most_recent        = true
}