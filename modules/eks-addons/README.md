# EKS addons module

This terraform module provides an easy way to install addons on an existing EKS cluster.

## Requirements

|   Name    | Version     |
| --------- | ----------- |
| terraform | `>= 1.3` |
| aws       | `>= 2.13` |

## Providers

| Name | Version  |
| ---- | -------- |
| aws  | `~> 4.76` |

## Inputs

| Name                 | Description                                                     | Type     | Default           | Required |
| -------------------- | --------------------------------------------------------------- | -------- | ----------------- | :------: |
| cluster\_name        | The EKS cluster name                                            | `string` | n/a               |   yes    |
| ebs\_csi\_driver     | An object list defining EBS CSI Driver addon configuration      | `object` | `{enabled=false}` |    no    |
| snapshot\_controller | An object list defining Snapshot Controller addon configuration | `object` | `{enabled=false}` |    no    |
| coredns              | An object list defining coredns addon configuration             | `object` | `{enabled=false}` |    no    |
| kube\_proxy          | An object list defining kube-proxy addon configuration          | `object` | `{enabled=false}` |    no    |
| vpc\_cni             | An object list defining VPC CNI addon configuration             | `object` | `{enabled=false}` |    no    |

Each object can be configured with the following parameters:

|   Name  |                           Description                                                                  | Type     | Default     | Required |
| ------- | ------------------------------------------------------------------------------------------------------ | -------- | ----------- | -------- |
| enabled | Whether to enable the addon or not.                                                                    | `bool`   | `false`     | No       |
| version | The addon version.                                                                                     | `string` | latest      | No       |
| resolve_conflicts | How to resolve conflicts when migrating from self-managed add-ons. Can be NONE or OVERWRITE. | `string` | `OVERWRITE` | No       |
| configuration_values | How to modify the default addon configuration. See [below](#advanced-configuration) for further details. | `string` | N/A | No

Moreover, `ebs_csi_driver` and `vpc_cni` have the following parameter:

|   Name                   |                           Description                                                                  | Type     | Default     | Required |
| ------------------------ | ------------------------------------------------------------------------------------------------------ | -------- | ----------- | -------- |
| service_account_role_arn |  The ARN of an existing IAM role to bind to the add-on's service account                               | `string` | n/a         | No       |

## Usage

```hcl
module "addons" {
  source         = "../vendor/modules/aws/eks-addons"
  cluster_name   = "myekscluster"
  ebs_csi_driver = {
    enabled = true
    version = "v1.19.0-eksbuild.2"
  }
  snapshot_controller = {
    enabled = true
    version = "v8.2.0-eksbuild.1"
    configuration_values = file("snapshot-controller.json")
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
    configuration_values = file("coredns.json")
  }
}

```

## Check the correct version

To understand which is the correct addon version based on EKS version, use the following command:

```bash
aws eks describe-addon-versions \
  --kubernetes-version <kubernetes-version> \
  --addon-name <addon-name>

# Example - list all the available versions

aws eks describe-addon-versions \
  --kubernetes-version 1.25 \
  --addon-name kube-proxy

# Example - get the default version
aws eks describe-addon-versions \
  --kubernetes-version 1.25 \
  --addon-name kube-proxy \
  | jq -r '.addons[].addonVersions[] | select(.compatibilities[0].defaultVersion) | .addonVersion'
```

## Advanced configuration

EKS addons can be configured to behave differently from the default.

Custom configurations include:

- Tolerations
- Node selectors
- Environment variables
- Limits and requests

To specify your needed configuration do the following:

1. Retrieve the correct json schema for your target addon and version

Use this command:

```bash
aws eks describe-addon-configuration \
  --addon-name <addon-name> \
  --addon-version <addon-version> | jq -r '.configurationSchema' > addon-config.json

# Example

aws eks describe-addon-configuration \
--addon-name kube-proxy \
--addon-version v1.25.6-eksbuild.1 | jq -r '.configurationSchema' > kube-proxy-config.json

```

2. Create your custom configuration files.

See the [blog](https://aws.amazon.com/blogs/containers/amazon-eks-add-ons-advanced-configuration/) for further details.
See also the [example](../../examples/eks-addons/README.md) for some references.

You can also validate your json against the schema from the step 1:

```bash
jsonschema -i my-custom-config.json addon-config.json
```
