# Snapshot controller

<!-- <KFD-DOCS> -->

CSI snapshotter is part of Kubernetes implementation of Container Storage Interface (CSI).

## Requirements

- Kubernetes >= `1.17.0`
- Kustomize >= `v3.5.3`

## Image repositories

* Snapshot Controller: `registry.sighup.io/fury/sig-storage/snapshot-controller`

## Deployment

You can deploy the snapshot-controller by including the package in your kustomize project:

`kustomization.yaml` file extract:
```yaml
...

resources:
  - katalog/snapshot-controller

...
```

You can then apply your kustomize project by running the following command:

```bash
kustomize build | kubectl apply -f -
```

<!-- Links -->

<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)


