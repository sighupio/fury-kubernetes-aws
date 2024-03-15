# Snapshot controller maintenance

To maintain the Snapshot controller package, you should follow this steps.

Download the latest release for the CSI snapshotter component here: <https://github.com/kubernetes-csi/external-snapshotter> and extract it on `/tmp` folder.

```bash
wget -P /tmp https://github.com/kubernetes-csi/external-snapshotter/archive/refs/tags/v7.0.0.tar.gz
tar -xf /tmp/v7.0.0.tar.gz -C /tmp
```

Build manifests for the CRDs and the snapshotter with (for example):

```bash
kustomize build /tmp/external-snapshotter-7.0.0/client/config/crd > built-crds.yaml
kustomize build /tmp/external-snapshotter-7.0.0/deploy/kubernetes/snapshot-controller > built-snapshot-controller.yaml
```

Check the differences between:

- `built-crds.yaml` and `./crds/crds.yaml`
- `built-snapshot-controller.yaml` and `./deploy-snapshot-controller.yaml`

What was changed:

- snapshot-controller Deployment replicas from 2 to 1
