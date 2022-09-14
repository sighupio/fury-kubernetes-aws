# IAM for AWS Load Balancer controller

This terraform module provides an easy way to generate AWS Load Balancer controller required IAM permissions.

> ⚠️ **Warning**: this module uses ["IAM Roles for ServiceAccount"](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html) to inject AWS credentials inside cluster autoscaler pods

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

|            Name                              |               Description                    |
| -------------------------------------------- | -------------------------------------------- |
| load\_balancer\_controller\_patches          | Load Balancer controller SA Kustomize patch  |
| load\_balancer\_controller\_iam\_role\_arn   | Load Balancer controller IAM role arn        |


## Usage

```hcl
module "load_balancer_controller_iam_role" {
  source             = "../vendor/modules/aws/iam-for-load-balancer-controller"
  cluster_name       = "myekscluster"
}
```
