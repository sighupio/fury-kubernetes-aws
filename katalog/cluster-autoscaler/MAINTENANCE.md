# Cluster Autoscaler maintenance

To maintain the clusterautoscaler package, you should follow this steps.

Build the new helm template with the following command:

```bash
helm repo add autoscaler https://kubernetes.github.io/autoscaler

helm template cluster-autoscaler autoscaler/cluster-autoscaler -n kube-system \
  --set cloudProvider=aws \
  --set 'autoDiscovery.clusterName'=changeme \
  --set fullnameOverride=cluster-autoscaler \
  --set awsRegion=eu-west-1 > built.yaml
```

Check the differences with `deploy.yaml` file and change accordingly.

What was changed:

- Removed unnecessary helm tags from the manifests and replaced with `app: cluster-autoscaler` when applicable.
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
