# Ansible Role: Etcd
Install, backup and restore Etcd.

## Installation
```yaml
name: Install etcd on all hosts
hosts: etcd
roles:
  - etcd
vars:
  etcd_certs_local_dir: "../secrets/pki/etcd"
```

This roles creates the Etcd PKI and saves in `etcd_certs_local_dir` on the local
machine the client certificate needed by Kubernetes API server.

## Restore
To perform the restore of an Etcd installation, first retrieve the database
snapshot and the PKI backup (default location of latest backup is
`/var/backups/etcd/current-etcd-backup.db.gz`).

```sh
$ scp -pr root@etcd:/var/backups/etcd/current-etcd-backup.db.gz
$ mkdir restore
$ tar -xzvf current-etcd-backup.db.gz -C restore
x var/backups/etcd/201810230820-backup.db
x etc/etcd/pki/
x etc/etcd/pki/etcdctl-client.pem
x etc/etcd/pki/etcdctl-client-key.pem
x etc/etcd/pki/apiserver-client.csr
x etc/etcd/pki/cfssl-default.json
x etc/etcd/pki/peer.pem
x etc/etcd/pki/apiserver-client.pem
x etc/etcd/pki/apiserver-client-key.pem
x etc/etcd/pki/server.pem
x etc/etcd/pki/ca-config.json
x etc/etcd/pki/server-key.pem
x etc/etcd/pki/etcdctl-client.csr
x etc/etcd/pki/peer.csr
x etc/etcd/pki/server.csr
x etc/etcd/pki/ca-key.pem
x etc/etcd/pki/ca-csr.json
x etc/etcd/pki/ca.csr
x etc/etcd/pki/ca.pem
x etc/etcd/pki/peer-key.pem
```

Now we can define a playbook like the following.
```yaml
name: Install etcd on all hosts
hosts: etcd
roles:
  - etcd
vars:
  etcd_restore: true
  etcd_restore_pki_local_files:
    - restore/etc/etcd/pki/ca-key.pem
    - restore/etc/etcd/pki/ca.pem
  etcd_restore_snapshot_local_file: restore/var/backups/etcd/201810230820-backup.db
  etcd_restore_snapshot_remote_file: /tmp/snapshot.db
```

Check that everything is working.
```sh
$ ssh root@etcd
# ETCDCTL_API=3 etcdctl --cacert=/etc/etcd/pki/ca.pem \
  --cert=/etc/etcd/pki/etcdctl-client.pem \
  --key=/etc/etcd/pki/etcdctl-client-key.pem \
  endpoint health
127.0.0.1:2379 is healthy: successfully committed proposal: took = 1.383705ms
```

When invoked with `etcd_restore: true` the role will first install Etcd on the
target hosts, then restore the PKI with the files listed in
`etcd_restore_pki_local_files` and finally restore Etcd from the snapshot in
`etcd_restore_snapshot_remote_file`.
