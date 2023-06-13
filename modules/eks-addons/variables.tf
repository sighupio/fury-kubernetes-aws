variable "cluster_name" {
  type        = string
  description = "Name of cluster where addons will be installed"
}

variable "ebs_csi_driver" {
  description = "Enable and configure EBS CSI Driver"
  type = object({
    enabled           = optional(bool, false)
    version           = optional(string)
    resolve_conflicts = optional(string, "OVERWRITE")
  })
  default = {}
}

variable "coredns" {
  description = "Enable and configure Coredns"
  type = object({
    enabled           = optional(bool, false)
    version           = optional(string)
    resolve_conflicts = optional(string, "OVERWRITE")
  })
  default = {}
}

variable "kube_proxy" {
  description = "Enable and configure kube-proxy"
  type = object({
    enabled           = optional(bool, false)
    version           = optional(string)
    resolve_conflicts = optional(string, "OVERWRITE")
  })
  default = {}
}

variable "vpc_cni" {
  description = "Enable and configure VPC CNI"
  type = object({
    enabled           = optional(bool, false)
    version           = optional(string)
    resolve_conflicts = optional(string, "OVERWRITE")
  })
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to all resources"
  default     = {}
}
