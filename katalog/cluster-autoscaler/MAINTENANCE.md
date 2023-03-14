# Cluster Autoscaler maintenance

To maintain the clusterautoscaler package, you should follow these steps.

Build the new helm template with the following command:

```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler

helm template cluster-autoscaler autoscaler/cluster-autoscaler -n kube-system \
  --set cloudProvider=aws \
  --set 'autoDiscovery.clusterName'=changeme \
  --set fullnameOverride=cluster-autoscaler \
  --set awsRegion=eu-west-1 > built.yaml
```

Check the differences with `base/deploy.yaml` file and change accordingly.

What was changed:

- Removed unnecessary helm tags from the manifests and replaced with `app: cluster-autoscaler` when applicable, to maintain compatibility with older cluster-autoscaler package versions.
- cluster-autoscaler command changed to:

  ```yaml
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
    - --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/$(CLUSTER_NAME)
  ```

- Added env var `CLUSTER_NAME` to the deployment, to simplify patching
- Added requests and limits
- Removed PodDisruptionBudget

Add the new EKS version folder like the existing v1.21.x, v1.22.x, v1.23.x, v1.24.x, v1.25.x, etc. if needed.