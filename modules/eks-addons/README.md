# EKS addons module

This terraform module provides an easy way to install addons on an existing EKS cluster.

## Requirements

|   Name    | Version     |
| --------- | ----------- |
| terraform | `>= 1.3` |
| aws       | `~> 3.76` |

## Providers

| Name | Version  |
| ---- | -------- |
| aws  | `~> 3.76` |

## Inputs

|         Name         |              Description                                   |     Type      | Default           | Required |
| -------------------- | ---------------------------------------------------------- | ------------- | ----------------- | :------: |
| cluster\_name        | The EKS cluster name                                       | `string`      | n/a               | yes      |
| ebs\_csi\_driver     | An object list defining EBS CSI Driver addon configuration | `object`      | `{enabled=false}` | no       |
| coredns              | An object list defining coredns addon configuration        | `object`      | `{enabled=false}` | no       |
| kube\_proxy          | An object list defining kube-proxy addon configuration     | `object`      | `{enabled=false}` | no       |
| vpc\_cni             | An object list defining VPC CNI addon configuration        | `object`      | `{enabled=false}` | no       |

Each object can be configured with the following parameters:
|   Name  |                           Description                                                                  | Type     | Default     | Required |
| ------- | ------------------------------------------------------------------------------------------------------ | -------- | ----------- | -------- |
| enabled | Whether to enable the addon or not.                                                                    | `bool`   | `false`     | No       |
| version | The addon version.                                                                                     | `string` | latest      | No       |
| resolve_conflicts | How to resolve conflicts when migrating from self-managed add-ons. Can be NONE or OVERWRITE. | `string` | `OVERWRITE` | No       |

## Usage

```hcl
module "addons" {
  source         = "../vendor/modules/aws/eks-addons"
  cluster_name   = "myekscluster"
  ebs_csi_driver = {
    enabled = true
    version = "v1.19.0-eksbuild.2"
  }
  coredns = {
    enabled = true
    resolve_conflicts = "NONE"
  }
  kube_proxy = {
    enabled = true
  }
  vpc_cni = {
    enabled = true
  }
}

```
