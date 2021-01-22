# Fury Kubernetes AWS Module version unreleased

SIGHUP team maintains this module updated and tested. This release contains improvements and new features.

Continue reading the [Changelog](#changelog) to discover them:

## Changelog

- Adding crl cron for vpn servers. The update is scheduled every 5 minutes. All the certs and crl definitions will be updated by furyagent.
- Fixing the output for the `openvpn-furyagent.yml` with the correct server list
- Migrate the s3-furyagent module to [fury-kubernetes-furyagent](https://github.com/sighupio/fury-kubernetes-furyagent)


## Upgrade path

Simply upgrade from the previous version. No changes needed.

