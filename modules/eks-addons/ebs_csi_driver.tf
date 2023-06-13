/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_driver.version
  resolve_conflicts        = var.ebs_csi_driver.resolve_conflicts
  service_account_role_arn = var.ebs_csi_driver.service_account_role_arn
  tags                     = var.tags
  count                    = var.ebs_csi_driver.enabled ? 1 : 0
}
