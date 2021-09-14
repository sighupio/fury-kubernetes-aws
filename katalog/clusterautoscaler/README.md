# Cluster Autoscaler

To use this Katalog, patch it as follow:

`kustomization.yaml` :

```yaml

patches:
  - patches/clusterautoscaler.yml

```


`clusterautoscaler.yml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cluster-autoscaler
  namespace: kube-system
spec:
  template:
    spec:
      serviceAccountName: cluster-autoscaler
      containers:
        - name: cluster-autoscaler
          command:
            - ./cluster-autoscaler
            - --v=4
            - --stderrthreshold=info
            - --cloud-provider=aws
            - --skip-nodes-with-local-storage=false
            - --expander=least-waste
            - --nodes=0:1:k8s-fury-k8s-job-asg
```

And add argument like `--nodes=0:1:k8s-fury-k8s-job-asg` where `k8s-fury-k8s-job-asg` is the autoscaling group name, and 0 is the min and 1 the max number of nodes.
