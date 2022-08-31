# Cluster Autoscaler

<!-- <KFD-DOCS> -->

A component that automatically adjusts the size of a Kubernetes Cluster so that all pods have a place to run and there
are no unneeded nodes. Supports several public cloud providers. Version 1.0 (GA) was released with kubernetes 1.8.

## Requirements

- Kubernetes >= `1.23.0`
- Kustomize >= `v3.3.X`

## Image repository and tag

* Cluster autoscaler image: `registry.sighup.io/autoscaling/cluster-autoscaler:v1.23.0`
* Cluster autoscaler repo: [Cluster autoscaler at Github][github]

## Deployment

You can deploy cluster autoscaler in your EKS cluster by including the package in your kustomize project:

`kustomization.yaml` file extract:
```yaml
...

resources:
  - katalog/cluster-autoscaler

...
```

you need then to patch the service account, the cluster name (for example `mycluster`) and the region (for example `eu-west-1`) as follows:

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
          command:
            - ./cluster-autoscaler
            - --cloud-provider=aws
            - --namespace=kube-system
            - --logtostderr=true
            - --stderrthreshold=info
            - --v=4
            - --scale-up-from-zero
            - --skip-nodes-with-local-storage=false
            - --expander=least-waste
            - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/mycluster
          env:
            - name: AWS_REGION
              value: "eu-west-1"
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

Refer to the Terraform module [iam-for-cluster-autoscaler](../../modules/iam-for-cluster-autoscaler) to create the IAM role.

You can then apply your kustomize project by running the following command:

```bash
kustomize build | kubectl apply -f -
```

<!-- Links -->

[github]: https://github.com/kubernetes/autoscaler

<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)


