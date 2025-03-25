<h1 align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/black-logo.png">
  <img alt="Shows a black logo in light color mode and a white one in dark color mode." src="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
</picture><br/>
  AWS Module
</h1>

![Release](https://img.shields.io/badge/Latest%20Release-v5.0.0-blue)
![License](https://img.shields.io/github/license/sighupio/module-aws?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <SD-DOCS> -->

**AWS Module** provides support AWS packages for [SIGHUP Distribution (SD)][kfd-repo].

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

**AWS Module** uses a collection of open source tools to make an EKS cluster on AWS production grade.

## Packages

The following packages are included in AWS Module:

| Package                                                                               | Version                           | Description                                                                                                 |
| ------------------------------------------------------------------------------------- | --------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| [cluster-autoscaler](katalog/cluster-autoscaler)                                      | `v1.29.0,v1.30.2,v1.31.0,v1.32.0` | A component that automatically adjusts the size of a Kubernetes Cluster                                     |
| [IAM role for cluster-autoscaler](modules/iam-for-cluster-autoscaler)                 | `-`                               | Terraform module to manage IAM role used by cluster-autoscaler                                              |
| [aws-node-termination-handler](katalog/node-termination-handler)                      | `v1.25.0`                         | Automatically manage graceful termination of pods in the event that one node is retired by AWS              |
| [aws-load-balancer-controller](katalog/load-balancer-controller)                      | `v2.12.0`                         | AWS Load Balancer Controller is a controller to help manage Elastic Load Balancers for a Kubernetes cluster |
| [IAM role for aws-load-balancer-controller](modules/iam-for-load-balancer-controller) | `-`                               | Terraform module to manage IAM role used by aws-load-balancer-controller                                    |
| [IAM role for aws-ebs-csi-driver](modules/iam-for-ebs-csi-driver)                     | `-`                               | Terraform module to manage IAM role used by EBS CSI driver                                                  |
| [EKS Addons](modules/eks-addons)                                                      | `-`                               | Terraform module to install the main EKS Addons (coredns, EBS CSI Driver, snapshot controller, VPC cni)     |


Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.29.x`           | :white_check_mark: | No known issues |
| `1.30.x`           | :white_check_mark: | No known issues |
| `1.31.x`           | :white_check_mark: | No known issues |
| `1.32.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional informations about previous releases of the modules.

## Usage

### Prerequisites

| Tool                        | Version    | Description                                                                                                                                                    |
| --------------------------- |------------| -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.25.0` | The recommended tool to download and manage SD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.3`  | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |
| [terraform][terraform-repo] | `>=1.3.0`  | Terraform is used to provision packages using modules. To learn how to use `terraform`, please refer to the [repository][terraform-repo].                      |

### Deployment

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: aws/cluster-autoscaler
    version: "v5.0.0"
  - name: aws/node-termination-handler
    version: "v5.0.0"
  - name: aws/load-balancer-controller
    version: "v5.0.0"

```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl legacy vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/aws`.

4. Define a `kustomization.yaml` that includes the `./vendor/katalog/aws` directory as resource.

```yaml
resources:
- ./vendor/katalog/aws/cluster-autoscaler/{v1.29.x,v1.30.x,v1.31.x,v1.32.x}
- ./vendor/katalog/aws/node-termination-handler
- ./vendor/katalog/aws/load-balancer-controller
```

> NB: some packages needs additional configurations (IAM roles), they will not work out of the box. Refer to each package documentation for more details.

5. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

<!-- Links -->

[kfd-repo]: https://github.com/sighupio/fury-distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kustomize-repo]: https://github.com/kubernetes-sigs/kustomize
[terraform-repo]: https://github.com/hashicorp/terraform
[kfd-docs]: https://docs.kubernetesfury.com/docs/distribution/
[compatibility-matrix]: https://github.com/sighupio/fury-kubernetes-aws/blob/master/docs/COMPATIBILITY_MATRIX.md

<!-- </SD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-aws/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
