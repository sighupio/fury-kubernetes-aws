# IAM for EBS CSI driver

This terraform module provides an easy way to generate EBS CSI driver required IAM permissions.

> ⚠️ **Warning**: this module uses ["IAM Roles for ServiceAccount"](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) to inject AWS credentials inside cluster autoscaler pods

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

|         Name         |              Description              |     Type      | Default | Required |
| -------------------- | ------------------------------------- | ------------- | ------- | :------: |
| cluster_name         | The EKS cluster name                  | `string`      | n/a     |   yes    |

## Outputs

|            Name                    |               Description               |
| ---------------------------------- | --------------------------------------- |
| ebs\_csi\_driver\_iam\_role\_arn   | EBS CSI driver IAM role arn             |


## Usage

```hcl
module "ebs_csi_driver_iam_role" {
  source             = "../vendor/modules/aws/iam-for-ebs-csi-driver"
  cluster_name       = "myekscluster"
}
```
