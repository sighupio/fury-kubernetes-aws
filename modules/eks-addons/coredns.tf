/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "aws_eks_addon" "coredns" {
  cluster_name         = var.cluster_name
  addon_name           = "coredns"
  addon_version        = var.coredns.version
  resolve_conflicts    = var.coredns.resolve_conflicts
  tags                 = var.tags
  count                = var.coredns.enabled ? 1 : 0
  configuration_values = var.coredns.configuration_values != null ? var.coredns.configuration_values : <<EOF
{
  "tolerations": [
    {
      "operator": "Exists"
    }
  ]
}
EOF
}
