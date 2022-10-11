# EBS CSI driver maintenance

To maintain the EBS CSI driver package, you should follow this steps.

Build the new helm template with the following command:

```bash
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update

helm template aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver -n kube-system \
  --api-versions=snapshot.storage.k8s.io/v1 \
  --set 'node.tolerateAllTaints'=true > built-ebs.yaml
```

> ⚠️ `--api-versions=snapshot.storage.k8s.io/v1` is mandatory since without connecting to a real cluster, Helm cannot determine the cluster capabilities, and the snapshotter sidecar is injected only if the cluster supports it.

Then, you should update the `ebs-csi-driver` package with the new `built-ebs.yaml` file.

Check the differences with `deploy-ebs-driver.yaml` file and change accordingly.

What was changed:
- removed all the empty references to secrets or configmaps
- removed PodDisruptionBudget

## Snapshotter side component

Download the latest release for the CSI snapshotter component here: https://github.com/kubernetes-csi/external-snapshotter and extract it on `/tmp` folder.

Build manifests for the CRDs and the snapshotter with (for example):

```bash
kustomize build /tmp/external-snapshotter-6.0.1/client/config/crd > built-crds.yaml
kustomize build /tmp/external-snapshotter-6.0.1/deploy/kubernetes/snapshot-controller > built-snapshot-controller.yaml
```

Check the differences between:
- `built-crds.yaml` and `./crds/crds.yaml`
- `built-snapshot-controller.yaml` and `./deploy-snapshot-controller.yaml`

What was changed: 
- snapshot-controller Deployment replicas from 2 to 1