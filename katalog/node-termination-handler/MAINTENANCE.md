# aws-node-termination-handler maintenance

To maintain the aws-node-termination-handler package, you should follow these steps.

Build the new helm template with the following command:

```bash
helm repo add eks https://aws.github.io/eks-charts

helm template aws-node-termination-handler \
  --namespace kube-system \
  --set enableSpotInterruptionDraining="true" \
  --set enableRebalanceMonitoring="true" \
  --set enableScheduledEventDraining="false" \
  --set enablePrometheusServer="true" \
  --set podMonitor.create="true" \
  eks/aws-node-termination-handler > built.yaml
```

Check the differences with `deploy.yaml` file and change accordingly.

What was changed:

- Removed unnecessary helm tags from the manifests and replaced with `app: aws-node-termination-handler` when applicable to maintain compatibility with older aws-node-termination-handler package versions.
- Changed the image in the manifest as `aws-node-termination-handler`, since the image is managed on the kustomization.yaml file
- Removed PodSecurityPolicy from the generated manifest
