/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = var.cluster_name
  addon_name        = "kube-proxy"
  addon_version     = var.kube_proxy.version
  resolve_conflicts = var.kube_proxy.resolve_conflicts
  tags              = var.tags
  count             = var.kube_proxy.enabled ? 1 : 0
}
