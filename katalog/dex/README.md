# Dex

Dex is an identity provider and authentication solution that uses OpenID
Connect. This package deploys Dex to authenticate users via LDAP.


## Requirements

- Kubernetes >= `1.10.0`
- Kustomize >= `v1`


## Image repository and tag

* Dex image: `quay.io/dexidp/dex:v2.13.0`
* Dex repo: https://github.com/dexidp/dex


## Configuration

Fury distribution Dex is deployed with following configuration:

- Replica number: `1`
- Listens on port `5556`
- Resource limits are `250m` for CPU and `200Mi` for memory


## Deployment

You can deploy Dex by running the following command in the root of the project:

```shell
$ kustomize build | kubectl apply -f -
```


## License

For license details please see [LICENSE](https://sighup.io/fury/license)
