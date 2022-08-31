/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

output "load_balancer_controller_patches" {
  description = "AWS load balancer controller Kubernetes resources patches"
  value       = <<EOT
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: ${module.aws_lb_controller_iam_assumable_role.this_iam_role_arn}
  name: aws-load-balancer-controller
  namespace: kube-system
EOT
}

output "load_balancer_controller_iam_role_arn" {
  description = "AWS load balancer controller IAM role"
  value       = module.aws_lb_controller_iam_assumable_role.this_iam_role_arn
}