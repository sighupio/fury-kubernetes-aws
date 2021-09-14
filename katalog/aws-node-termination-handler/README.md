# AWS-termination-node-handler

This setup was generated using this [helmchart](https://github.com/aws/eks-charts/tree/master/stable/aws-node-termination-handler)
To simplify the setup i build this [script](./helm-render.sh)

## When do you need this?

If you choose for your cluster, some nodepool with spot instances, then probably you need this. 

## What does this service do?

Simplifying it, basically this service listen 3 different kinds of events/notifications:

1. Monitors EC2 Metadata for Scheduled Maintenance Events
2. Monitors EC2 Metadata for Spot Instance Termination Notifications
3. Monitors EC2 Metadata for Rebalance Recommendation Notifications

Given those kind of informations, it will 

1. (optional) send a notification to a slack channel (you can configure the webhook like in this [example](../../example/aws-node-termination-handler/kustomization.yaml))
2. drain the node selected relocating the workloads elsewhere

This behavior helps to avoid disruption in a production environment.

## Documentation reference

- Official Github repository: <https://github.com/aws/aws-node-termination-handler>
- Official HelmChart repository: <https://github.com/aws/eks-charts/tree/master/stable/aws-node-termination-handler>

