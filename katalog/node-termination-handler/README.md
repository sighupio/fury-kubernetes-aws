# AWS node termination handler

<!-- <SD-DOCS> -->

This package ensures that the Kubernetes control plane responds appropriately to events that can cause your EC2 instance to become unavailable, such as EC2 maintenance events, EC2 Spot interruptions, ASG Scale-In, ASG AZ Rebalance, and EC2 Instance Termination via the API or Console.
If not handled, your application code may not stop gracefully, take longer to recover full availability, or accidentally schedule work to nodes that are going down.

This package is deployed as Instance Metadata Service Processor to monitor:

- EC2 Metadata for Scheduled Maintenance Events
- EC2 Metadata for Spot Instance Termination Notifications
- EC2 Metadata for Rebalance Recommendation Notifications

## Requirements

- Kubernetes >= `1.21.0`
- Kustomize >= `v3.5.3`

## Image repository and tag

- AWS node termination handler image: `registry.sighup.io/fury/aws-ec2/aws-node-termination-handler`
- AWS node termination handler repo: [AWS node termination handler at Github][github]

## Deployment

You can deploy AWS node termination handler by running the following command:

```bash
kustomize build | kubectl apply -f -
```

<!-- Links -->

[github]: https://github.com/aws/aws-node-termination-handler

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)


