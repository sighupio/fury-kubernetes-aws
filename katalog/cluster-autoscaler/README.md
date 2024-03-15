# Cluster Autoscaler

<!-- <KFD-DOCS> -->

A component that automatically adjusts the size of a Kubernetes Cluster so that all pods have a place to run and there are no unneeded nodes. Supports several public cloud providers. Version 1.0 (GA) was released with Kubernetes 1.8.

## Requirements

- Kubernetes >= `1.21.0`
- Kustomize = `v3.5.3`

## Image repository and tag

- Cluster autoscaler image: `registry.sighup.io/autoscaling/cluster-autoscaler:v1.25.0,v1.26.4,v1.27.2,v1.28.2,v1.29.0`
- Cluster autoscaler repo: [Cluster autoscaler at Github][ca-github]

## Deployment

You can deploy cluster autoscaler in your EKS cluster by including the package in your Kustomize project:

`kustomization.yaml` file extract:

```yaml
...

resources:
  - katalog/cluster-autoscaler/{v1.24.x,v1.25.x,v1.26.x,v1.27.x,v1.28.x,v1.29.x}

...
```

Refer to the Terraform module [iam-for-cluster-autoscaler](../../modules/iam-for-cluster-autoscaler) to create the IAM role and the required kustomize patches automatically.

If still you want to create everything manually without using our Terraform Module, you need to patch the service account, the cluster name (for example `mycluster`) and the region (for example `eu-west-1`) as follows:

`sa-patch.yaml`

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789123:role/your-role-name
  name: cluster-autoscaler
  namespace: kube-system
```

`cluster-autoscaler-patch.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: cluster-autoscaler
  name: cluster-autoscaler
  namespace: kube-system
spec:
  template:
    spec:
      containers:
        - name: aws-cluster-autoscaler
          env:
            - name: AWS_REGION
              value: "eu-west-1"
            - name: CLUSTER_NAME
              value: mycluster
```

and then add on the `kustomization.yaml` file the patches:

`kustomization.yaml` file extract:

```yaml
...

patchesStrategicMerge:
  - sa-patch.yaml
  - cluster-autoscaler-patch.yaml

...
```

You can then apply your kustomize project by running the following command:

```bash
kustomize build | kubectl apply -f -
```

<!-- Links -->

[ca-github]: https://github.com/kubernetes/autoscaler

<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)
