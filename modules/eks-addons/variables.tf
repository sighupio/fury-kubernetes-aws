/**
 * Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

variable "cluster_name" {
  type        = string
  description = "Name of cluster where addons will be installed"
}

variable "ebs_csi_driver" {
  description = "Enable and configure EBS CSI Driver"
  type = object({
    enabled                  = optional(bool, true)
    version                  = optional(string)
    resolve_conflicts        = optional(string, "OVERWRITE")
    service_account_role_arn = optional(string)
    configuration_values     = optional(any)
  })
  default = {}
}

variable "coredns" {
  description = "Enable and configure Coredns"
  type = object({
    enabled              = optional(bool, true)
    version              = optional(string)
    resolve_conflicts    = optional(string, "OVERWRITE")
    configuration_values = optional(any)
  })
  default = {}
}

variable "kube_proxy" {
  description = "Enable and configure kube-proxy"
  type = object({
    enabled              = optional(bool, true)
    version              = optional(string)
    resolve_conflicts    = optional(string, "OVERWRITE")
    configuration_values = optional(any)
  })
  default = {}
}

variable "vpc_cni" {
  description = "Enable and configure VPC CNI"
  type = object({
    enabled                  = optional(bool, true)
    version                  = optional(string)
    resolve_conflicts        = optional(string, "OVERWRITE")
    service_account_role_arn = optional(string)
    configuration_values     = optional(any)
  })
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources"
  default     = {}
}
