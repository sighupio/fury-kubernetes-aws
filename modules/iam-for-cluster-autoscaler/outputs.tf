/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

output "cluster_autoscaler_patches" {
  description = "cluster-autoscaler Kubernetes resources patches"
  value       = <<EOT
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: ${module.cluster_autoscaler_iam_assumable_role.this_iam_role_arn}
  name: cluster-autoscaler
  namespace: kube-system
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: cluster-autoscaler
  name: cluster-autoscaler
  namespace: kube-system
spec:
  template:
    spec:
      containers:
        - name: aws-cluster-autoscaler
          env:
            - name: AWS_REGION
              value: ${var.region}
            - name: CLUSTER_NAME
              value: ${var.cluster_name}
EOT
}

output "cluster_autoscaler_iam_role_arn" {
  description = "cluster-autoscaler IAM role"
  value       = module.cluster_autoscaler_iam_assumable_role.this_iam_role_arn
}
