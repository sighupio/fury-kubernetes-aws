<h1>
    <img src="https://github.com/sighupio/fury-distribution/blob/main/docs/assets/fury-epta-white.png?raw=true" align="left" width="90" style="margin-right: 15px"/>
    Kubernetes Fury AWS
</h1>

![Release](https://img.shields.io/badge/Latest%20Release-v4.0.0-blue)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-aws?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <KFD-DOCS> -->

**Kubernetes Fury AWS** provides support AWS packages for [Kubernetes Fury Distribution (KFD)][kfd-repo].

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Overview

**Kubernetes Fury AWS** uses a collection of open source tools to make an EKS cluster on AWS production grade.

## Packages

The following packages are included in Kubernetes Fury AWS:

| Package                                                                               | Version                         | Description                                                                                                 |
| ------------------------------------------------------------------------------------- | ------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| [cluster-autoscaler](katalog/cluster-autoscaler)                                      | `v1.23.1,v1.24.0,1.25.0,1.26.4` | A component that automatically adjusts the size of a Kubernetes Cluster                                     |
| [IAM role for cluster-autoscaler](modules/iam-for-cluster-autoscaler)                 | `-`                             | Terraform module to manage IAM role used by cluster-autoscaler                                              |
| [aws-node-termination-handler](katalog/node-termination-handler)                      | `v1.19.0`                       | Automatically manage graceful termination of pods in the event that one node is retired by AWS              |
| [aws-load-balancer-controller](katalog/load-balancer-controller)                      | `v2.6.0`                        | AWS Load Balancer Controller is a controller to help manage Elastic Load Balancers for a Kubernetes cluster |
| [IAM role for aws-load-balancer-controller](modules/iam-for-load-balancer-controller) | `-`                             | Terraform module to manage IAM role used by aws-load-balancer-controller                                    |
| [snapshot-controller](katalog/snapshot-controller)                                    | `v6.2.1`                        | Snapshot controller to enable snapshotting of the Amazon EBS driver.                                        |
| [IAM role for aws-ebs-csi-driver](modules/iam-for-ebs-csi-driver)                     | `-`                             | Terraform module to manage IAM role used by EBS CSI driver                                                  |

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.24.x`           | :white_check_mark: | No known issues |
| `1.25.x`           | :white_check_mark: | No known issues |
| `1.26.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional informations about previous releases of the modules.

## Usage

### Prerequisites

| Tool                        | Version   | Description                                                                                                                                                    |
| --------------------------- |-----------| -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.6.0` | The recommended tool to download and manage KFD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.3` | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |
| [terraform][terraform-repo] | `>=1.3.0` | Terraform is used to provision packages using modules. To learn how to use `terraform`, please refer to the [repository][terraform-repo].                      |

### Deployment

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: aws/cluster-autoscaler
    version: "v4.0.0"
  - name: aws/node-termination-handler
    version: "v4.0.0"
  - name: aws/load-balancer-controller
    version: "v4.0.0"
  - name: aws/snapshot-controller
    version: "v4.0.0" 
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/aws`.

4. Define a `kustomization.yaml` that includes the `./vendor/katalog/aws` directory as resource.

```yaml
resources:
- ./vendor/katalog/aws/cluster-autoscaler/{v1.21.x,v1.22.x,v1.23.x,v1.24.x,v1.25.x}
- ./vendor/katalog/aws/node-termination-handler
- ./vendor/katalog/aws/load-balancer-controller
- ./vendor/katalog/aws/snapshot-controller
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

<!-- </KFD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-aws/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
