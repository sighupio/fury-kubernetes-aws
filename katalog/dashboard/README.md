# Kubernetes Dashboard

Kubernetes dashboard is a web-based UI to manage and operate on Kubernetes
cluster.

## Requirements

- Kubernetes >= `1.10.0`
- Kustomize >= `v1`


## Image repository and tag

* Dashboard image: `k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3`
* Dashboard repo: https://github.com/kubernetes/dashboard 
* Dashboard documentation (and user guide): https://github.com/kubernetes/dashboard/wiki


## Configuration

Fury distribution Dashboard is deployed with following configuration:

- Replica number: `1`
- Access with authentication token


## Deployment

You can deploy Dashboard by running following command in the root of the
project:

```shell
$ kustomize build | kubectl apply -f -
```

### Accessing Kubernetes Dashboard

You can access dashboard from your local host by starting local proxy server:

```shell
$ kubectl proxy
```

Then visiting the following endpoint from your browser:

```shell
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```

To learn how to access to dashboard with an Access Token please follow the
[example](../../examples/dashboard-add-user).

## License

For license details please see [LICENSE](https://sighup.io/fury/license)
