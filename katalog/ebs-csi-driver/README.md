# EBS CSI Driver

<!-- <KFD-DOCS> -->

The Amazon Elastic Block Store Container Storage Interface (CSI) Driver provides a CSI interface used by Container Orchestrators to manage the lifecycle of Amazon EBS volumes.
It's mandatory since EKS version 1.23.

## Requirements

- Kubernetes >= `1.20.0`
- Kustomize >= `v3.5.3`

## Image repository and tag

* AWS EBS CSI Driver image: `registry.sighup.io/fury/ebs-csi-driver/aws-ebs-csi-driver`
* CSI Node Driver registrar: `registry.sighup.io/fury/sig-storage/csi-node-driver-registrar`
* K8S livenessprobe: `registry.sighup.io/fury/sig-storage/livenessprobe`
* CSI Provisioner: `registry.sighup.io/fury/sig-storage/csi-provisioner`
* CSI Attacher: `registry.sighup.io/fury/sig-storage/csi-attacher`
* CSI Resizer: `registry.sighup.io/fury/sig-storage/csi-resizer`
* CSI Snapshotter: `registry.sighup.io/fury/sig-storage/csi-snapshotter`
* Snapshot Controller: `registry.sighup.io/fury/sig-storage/snapshot-controller`

## Deployment

You can deploy EBS CSI driver in your EKS cluster by including the package in your kustomize project:

`kustomization.yaml` file extract:
```yaml
...

resources:
  - katalog/ebs-csi-driver

...
```

Refer to the Terraform module [iam-for-ebs-csi-driver](../../modules/iam-for-ebs-csi-driver) to create the
IAM role and the required kustomize patches automatically.

If you still want to create everything manually without using our Terraform Module, you need to patch the service account like below:

`sa-patch.yaml`
```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789123:role/your-role-name
  name: ebs-csi-controller-sa
  namespace: kube-system
```



You can then apply your kustomize project by running the following command:

```bash
kustomize build | kubectl apply -f -
```

<!-- Links -->

[github]: https://github.com/kubernetes-sigs/aws-load-balancer-controller/

<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)


