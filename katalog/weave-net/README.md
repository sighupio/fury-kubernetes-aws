# Weave Net

Weave Net is a popular CNI plugin that creates a virtual network for Kubernetes
and provides one IP address per pod. It doesn’t require any configuration or
extra code to run.

## Requirements

- Kubernetes >= `1.10.0`
- Kustomize >= `v1`


## Image repository and tag

* Weave Net image: `weaveworks/weave-kube:2.4.1`
* Weave Net NPC image: `weaveworks/weave-npc:2.4.1`
* Weave Net repo: https://github.com/weaveworks/weave
* Weave Net documentation : https://www.weave.works/docs/net/latest/overview/


## Configuration

Fury distribution Weave Net is deployed with the following configuration:

- Metrics are scraped by Prometheus every `15s`


## Deployment

You can deploy Weave Net by running following command in the root of the project:

```shell
$ kustomize build | kubectl apply -f -
```


## Alerts

The followings Prometheus
[alerts](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)
are already defined for this package.

### weave-net.rules
| Parameter | Description | Severity | Interval |
|------|-------------|----------|:-----:|
| WeaveNetUnreachablePercentage | This alert fires if the unreachable percentage of a given weave-net pod was more than 0 in the last 10 minutes. | critical | 10m |
| WeaveNetUnreachablePeers | This alert fires if there were more than 0 unreachable weave-net peers in the last 10 minutes. | critical | 10m |
| WeaveNetPendingAllocations | This alert fires if there were more than 0 pending allocates on a given weave-net pod in the last 10 minutes. | warning | 10m |
| WeaveNetPendingClaim | This alert fires if there were more than 0 pendins claims on a given weave-net pod in the last 10 minutes. | warning | 10m |
| WeaveNetFailedConnections | This alert fires if a given weave-net pod was failing more than 0 conn/sec in the last 10 minutes based on a calculation made on a 1 minute time window. | warning | 10m |
| WeaveNetIPExhaustion | This alert fires if the utilisation of Weave-net IP address space was more than 85% in the last hour. | critical | 1h |


## License

For license details please see [LICENSE](https://sighup.io/fury/license)
