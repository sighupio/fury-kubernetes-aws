
helm repo add eks https://aws.github.io/eks-charts

helm template aws-node-termination-handler \
  --namespace kube-system \
  --set enableSpotInterruptionDraining="true" \
  --set enableRebalanceMonitoring="true" \
  --set enableScheduledEventDraining="false" \
  --set enablePrometheusServer="true" \
  --set webhookURLSecretName="pippo" \
  --set podMonitor.create="true" \
  eks/aws-node-termination-handler
