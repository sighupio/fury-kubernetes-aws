# IAM for cluster autoscaler

This terraform module provides an easy way to generate cluster autoscaler required IAM permissions.

> ⚠️ **Warning**: this module uses ["IAM Roles for ServiceAccount"](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html)
> to inject AWS credentials inside cluster autoscaler pods

## Requirements

|   Name    | Version     |
| --------- | ----------- |
| terraform | `>= 0.15.4` |
| aws       | `>= 3.37.0` |

## Providers

| Name | Version  |
| ---- | -------- |
| aws  | `>= 3.37.0` |

## Inputs

|         Name         |              Description              |     Type      | Default | Required |
| -------------------- | ------------------------------------- | ------------- | ------- | :------: |
| cluster_name         | The EKS cluster name                  | `string`      | n/a     |   yes    |

## Outputs

|            Name                    |               Description               |
| ---------------------------------- | --------------------------------------- |
| cluster\_autoscaler\_patches       | Cluster autoscaler SA Kustomize patch   |
| cluster\_autoscaler\_iam\_role\_arn  | Cluster autoscaler IAM role arn         |


## Usage

```hcl
module "cluster_autoscaler_iam_role" {
  source             = "../vendor/modules/aws/iam-for-cluster-autoscaler"
  cluster_name       = "myekscluster"
}
```
