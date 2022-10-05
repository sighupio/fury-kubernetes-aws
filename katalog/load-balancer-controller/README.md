# AWS Load Balancer controller

<!-- <KFD-DOCS> -->

AWS Load Balancer Controller is a controller to help manage Elastic Load Balancers for a Kubernetes cluster.

- It satisfies Kubernetes Ingress resources by provisioning Application Load Balancers.
- It satisfies Kubernetes Service resources by provisioning Network Load Balancers.

## Requirements

- Kubernetes >= `1.19.0`
- Kustomize >= `v3.5.3`
- [cert-manager][cert-manager]

## Image repository and tag

* AWS Load Balancer controller image: `registry.sighup.io/fury/amazon/aws-alb-ingress-controller:v2.4.3`
* AWS Load Balancer controller repo: [AWS Load Balancer controller at Github][github]

## Deployment

You can deploy AWS Load Balancer controller in your EKS cluster by including the package in your kustomize project:

`kustomization.yaml` file extract:
```yaml
...

resources:
  - katalog/load-balancer-controller

...
```

Refer to the Terraform module [iam-for-load-balancer-controller](../../modules/iam-for-load-balancer-controller) to create the
IAM role and the required kustomize patches automatically.

If still you want to create everything manually without using our Terraform Module, you need then to patch the service
account and the cluster name (for example `mycluster`) as follows:

`sa-patch.yaml`
```yaml
---
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::123456789123:role/your-role-name
  name: aws-load-balancer-controller
  namespace: kube-system
```

`load-balancer-controller-patch.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
spec:
  
  template:
   
    spec:
      containers:
        - name: controller
          env:
            - name: CLUSTER_NAME
              value: mycluster
```

and then add on the `kustomization.yaml` file the patches:

`kustomization.yaml` file extract:
```yaml
...

patchesStrategicMerge:
  - sa-patch.yaml
  - load-balancer-controller-patch.yaml

...
```

You can then apply your kustomize project by running the following command:

```bash
kustomize build | kubectl apply -f -
```

<!-- Links -->

[cert-manager]: https://github.com/sighupio/fury-kubernetes-ingress/tree/master/katalog/cert-manager 
[github]: https://github.com/kubernetes-sigs/aws-load-balancer-controller/

<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)


