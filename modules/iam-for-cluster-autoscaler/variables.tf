/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region, used for kustomize patches generation"
  type        = string
}

variable "autoscaler_iam_role_name_override" {
  description = "IAM role name for the Cluster Autoscaler"
  type        = string
  default     = ""
}
