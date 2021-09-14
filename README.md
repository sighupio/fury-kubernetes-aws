# Kubernetes Fury AWS

![logo](./fury-logo.svg)

## what is kuberneters fury AWS?

- what problems does it solve?
  ...

- what does "production ready" really means means

  TBD

## Compatibility

| Distribution Version / Kubernetes Version | 1.14.X             | 1.15.X             | 1.16.X             |
|-------------------------------------------|:------------------:|:------------------:|:------------------:|
| v1.15.4                                   |                    | :white_check_mark: |                    |
| v1.15.5                                   |                    | :white_check_mark: |                    |

- :white_check_mark: Compatible
- :warning: Has issues
- :x: Incompatible

### reference architecture

![cloudcraft.png](./doc-images/cloudcraft.png)
cloudcraft diagram [here](https://cloudcraft.co/view/ee4cd783-8f91-430b-85e3-255173b331e2?key=mvgzlsrnDoemUZKEykXX6Q)

#### Instances

- 2 bastions in different availability-zones
- 3 k8s master nodes in different availability-zones
- 2 k8s worker nodes in different availability-zones

#### Networking

- The incoming public incoming traffic will be routed into the pods services via an application load balancer
- 2 bastions machines are available in order to proxy commands from outside the cluster to the k8s master nodes via _ssh_
- VPN connection allow connecting directly to master nodes and worker nodes

### differences with installations using kubeadm

etcd is not managed by k8s (not running in a pod)
but is under systemd

...

TBD

---

## Features

Production ready multi-master setup

...

TBD

## prerequisites

there programs needs to be installed locally and available in `$PATH`

- install [furyctl](https://github.com/sighup-io/furyctl#install)
- install awscli
- install [furyagent](https://github.com/sighup-io/furyagent#install)
- install ansible
- install kustomize v1 (v2 is incompatible at the moment)
- install terraform
- install openvpn
- install git
- install git-crypt

---

## step-by-step cluster setup instructions

Create a new empty folder for the project and _cd_ into it

run `mkdir [project_name]`

> While working with infrastructure as code, it is highly encouraged to keep your infrastructure definition files under strict version control. This task is out of the scope of this tutorial, but you should probably want to do `git init` right now and `git commit` at all the checkpoints ;)

---

## Declaring dependencies in Furyfile

Create a _Furyfile_ in the project root with commons and AWS specific dependencies by running

> _Furyfile_ is used by _furyctl_ to download dependencies, for more info check [_furyctl's readme_](https://github.com/sighup-io/furyctl)

> _bases_ are manifests files for deploying basic Kubernetes' components.
> _modules_ are terraform modules for deploying the infrastructure and it's dependencies.
> _roles_ are ansible roles for deploying, configuring and managing Kubernetes infrastructure.

```
cat <<-EOF > Furyfile.yml
bases:
  - name: networking/weave-net
    version: master
  - name: aws/storageclass
    version: master

roles:
  - name: aws/etcd
    version: master
  - name: aws/furyagent
    version: master
  - name: aws/kube-control-plane
    version: master
  - name: openvpn/openvpn
    version: master

modules:
  - name: aws/aws-vpc
    version: master
  - name: aws/aws-kubernetes
    version: master
  - name: aws/s3-furyagent
    version: master
EOF

```

## Installing dependencies with furyctl

Run `furyctl install` while in the project root

It will create a folder called _vendor_ and then it will download all the dependencies that are defined in the _Furyfile_ into this folder.

---

Create the S3 bucket for the terraform state

using the _aws_ cli

```
export TERRAFORM_STATE_BUCKET_NAME=fury-tf-state
aws s3 mb s3://${TERRAFORM_STATE_BUCKET_NAME} --region eu-west-1
```

> change `fury-tf-state` with custom name and region

---

## scaffold folders

run

```
mkdir {secrets,terraform,ansible,manifests}
```

project folder should now look like this:

```
project_root
    ├── Furyfile.yml
    ├── ansible
    ├── manifests
    ├── secrets
    ├── terraform
    └── vendor
```

> We need to create the folder structure now because the output of some terraform commands creates files in the _ansible_ folder and otherwise the command will fail.

---

## Secrets

NB: the _secrets_ will contains all the keys and tokens required to operate the cluster, it is **highly encouraged** to encrypt this folder before pushing it to a remote repository using something like [git-crypt](https://github.com/AGWA/git-crypt)

Create a file with aws credentials running this command

```
touch secrets/aws-credentials.sh  && \
echo export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile [AWS_PROFILE]) >> secrets/aws-credentials.sh  && \
echo export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile [AWS_PROFILE]) >> secrets/aws-credentials.sh
```

> change [AWS_PROFILE] with you profile name or remove the `profile` flag to use default user

a file is created at _secrets/aws-credentials.sh_
open it and set **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**

> these credential are use by terraform to create the cluster

### Encrypting your secrets
To encrypt your secrets (considering you have setup `git-crypt` properly) you need to run this in your project root

run `git-crypt init`

then create a _.gitattributes_ file declaring the folder to encrypt:
```
cat <<-EOF > .gitattributes
secrets/** filter=git-crypt diff=git-crypt
EOF
```

Add some of your colleagues with the command
`git-crypt add-gpg-user USER_ID`

> We need to have your colleague's gpg public key in your keyring.
> You can add the gpg key with a command like `curl https://github.com/ralgozino.gpg | gpg --import`

And you're done. All the files under the `secrets` folder are now automatically encrypted.

---

## setup terraform state backend

Create file for the _terraform_ backend

```
cat <<-EOF > terraform/backend.tf
terraform {
  backend "s3" {
    bucket = "${TERRAFORM_STATE_BUCKET_NAME}"
    key    = "terraform"
    region = "eu-west-1"
  }

  required_version = ">= 0.11.11"
}
EOF
```

> The variable `TERRAFORM_STATE_BUCKET_NAME` was set in previous commands, in case you are using a different shell session and the env is not initialized change it with the name of the bucket previously created and set the region accordingly

---

## create ssh credential

Create a new ssh credential to be used as the key pair to access the new machines

> this step is not mandatory, you can use your own key, but for the sake fo simplicity we generate a new one

run this in the project root

`ssh-keygen -t rsa -b 4096 -f ./secrets/ssh-user`

---

### Optional: additional ssh keys

Additional ssh keys can be added when creating the machines by adding them in `terraform/keys` folder
one key per file

`mkdir terraform/keys`

example using github
`curl https://github.com/kandros.keys > terraform/keys/jaga.pub`

example using local key
`cat ~/.ssh/id_rsa.pub > terraform/keys/user.pub`

> all the keys found in _terraform/keys_ will be added to the machines in order to ssh into them

---

## Using a Makefile

create Makefile for terraform operations

> in order to simplify the complexity of bootstrapping the infrastructure, we will create a _Makefile_ with the operations already in the right order

```
cat <<-'EOF' > ./terraform/Makefile
creds = ../secrets/aws-credentials.sh

.PHONY: init plan run destroy

init:
	source $(creds) && terraform init

plan:
	source $(creds) && terraform validate && terraform plan

apply:
	source $(creds) && terraform apply -auto-approve

run:
	source $(creds) && terraform apply -auto-approve
	source $(creds) && mkdir -p ../ansible && terraform output -module=k8s inventory > ../ansible/hosts.ini
	source $(creds) && terraform output -module=k8s ecr-pusher > ../secrets/ecr.sh
	source $(creds) && terraform output -module=prod-furyagent furyagent_ansible_secrets > ../secrets/fury.yml

destroy:
	source $(creds) && terraform destroy

dep:
	cd .. && $(MAKE) dep
EOF
```

---

## Create aws VPC using terraform

Create file with terraform VPC

> change the variable `name` as it would be used for namespace or prefix the instances

```
cat <<- 'EOF' > terraform/main.tf
variable aws_region {
  default = "eu-west-1"
}

provider "aws" {
  region  = "${var.aws_region}"
  version = "1.60.0"
}

variable name {
  default = "try-fury"
}

variable env {
  default = "test"
}

variable ssh-public-key {
  default = "../secrets/ssh-user.pub"
}

variable ssh-private-key {
  default = "../secrets/ssh-user"
}

module "vpc" {
  source        = "../vendor/modules/aws/aws-vpc"
  name          = "${var.name}"
  env           = "${var.env}"
  vpc-cidr      = "10.100.0.0/16"
  region        = "${var.aws_region}"
  internal-zone = "sighup.io"
  bastion-ami   = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20190212.1-*"

  ssh-public-keys = [
    # examples to add additions keys
    # "${file("keys/user.pub")}"
    "${file(var.ssh-public-key)}",
  ]
}
EOF
```

> make sure to edit the `vpc.ssh-public-keys` if you need additional public ssh keys added to the machines

---

## bootstrap the cluster

run these commands

`cd terraform`
`make init`

---

### Optional: check terraform plan

from _terraform_ folder
run `make plan`

to validate plan and validate the configuration of terraform

---

run `make apply`

> this will setup the VPC and on aws with terraform

---

## Create the cluster

append k8s module to `terraform/main.tf`

> this is splitted from the previous `make run` because the module k8s property needs to get dynamic data from the first run

```
cat <<- 'EOF' >> terraform/main.tf

module "k8s" {
  source                             = "../vendor/modules/aws/aws-kubernetes"
  region                             = "${var.aws_region}"
  name                               = "${var.name}"
  env                                = "${var.env}"
  kube-master-ami                    = "KFD-Ubuntu-Master-1.15.5-2-*"
  kube-master-count                  = 3
  kube-master-type                   = "t3.medium"
  kube-private-subnets               = "${module.vpc.private_subnets}"
  kube-public-subnets                = "${module.vpc.public_subnets}"
  kube-domain                        = "${module.vpc.domain_zone}"
  kube-bastions                      = "${module.vpc.bastion_public_ip}"
  ssh-private-key                    = "${var.ssh-private-key}"
  s3-bucket-name                     = "sighup-${var.name}-${var.env}-agent"
  join-policy-arn                    = "${module.prod-furyagent.bucket_policy_join}"
  alertmanager-hostname              = "alertmanager.test.fury.sighup.io"

  kube-lb-internal-domains = [
    "grafana",
    "prometheus",
    "alertmanager",
    "kibana",
    "cerebro",
    "directory",
  ]

  kube-lb-external-enable-access-log = false

  kube-workers = [
    {
      kind  = "infra"
      count = 1
      type  = "t3.medium"
      kube-ami = "KFD-Ubuntu-Node-1.15.5-2-*"
     },
  ]

  ecr-repositories = []

  kube-workers-security-group = [
    {
      type        = "ingress"
      to_port     = 32080
      from_port   = 32080
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  ssh-public-keys = [
    "${file(var.ssh-public-key)}",
  ]
}

module "prod-furyagent" {
  source                = "../vendor/modules/aws/s3-furyagent"
  cluster_name          = "${var.name}"
  environment           = "${var.env}"
  aws_region            = "eu-west-1"
  furyagent_bucket_name = "sighup-${var.name}-${var.env}-agent"
}
EOF
```

> make sure to edit the `k8s.ssh-public-keys` if you need additional ssh public keys added to the machines

run `make init && make run`

> this will create the machines on aws with terraform

> `make run` does terraform apply and also outpus files with stack info to be used by ansible

---

### Checkpoint

now everything is deployed on aws

> hosts.ini has been created by terraform's output in _ansible_ folder when we used `make run`

> This is a good time to make your first `git commit` if you haven't done it yet :)

---

## Setup control-plane using ansible

create ansible config file

```bash
cat <<-EOF > ./ansible/ansible.cfg
[defaults]
inventory = hosts.ini
host_key_checking = False
roles_path = ../vendor/roles
timeout = 60

# Use the YAML callback plugin.
stdout_callback = yaml
# Use the stdout_callback when running ad-hoc commands.
bin_ansible_callbacks = True
EOF
```

---

### checkpoint

verify that the machines are reachable by ansible run `ansible all -m ping` while in the _ansible_ folder

> If you are using _git crypt_, you might get a connection error from ansible. Check that the _ssh private key_ file has the right permissions, it should be 0600. If it doesn't have the right permissions run `chmod 0600 ../secrets/ssh-user`
---

## prepare cluster playbook

create ansible playbook to setup cluster

```bash
cat <<-'EOF' > ansible/cluster.yml

- name: Installing and configuring furyagent
  hosts: master
  become: true
  vars:
    furyagent_configure_master: true
    furyagent_configure_etcd: true
    furyagent_etcd_backup: false
  vars_files:
    - '../secrets/fury.yml'
  roles:
    - aws/furyagent

- name: Etcd cluster preparation
  hosts: master
  become: true
  roles:
    - aws/etcd

- name: Control plane configuration
  hosts: master
  become: true
  vars:
    kubernetes_api_SAN:
      - '{{ public_lb_address }}'
    kubernetes_kubeconfig_path: '../secrets/users'
    kubernetes_cluster_name: 'fury-test'
    kubernetes_users_org: sighup
    kubernetes_control_plane_address: '{{control_plane_endpoint}}:6443'
    kubernetes_version: '1.15.5'
  vars_files:
    - '../secrets/fury.yml'
  roles:
    - aws/kube-control-plane
EOF
```

---

## run cluster playbook

`cd` into ansible folder and run
run `ansible-playbook cluster.yml`

---

### checkpoint

try to ssh into a master to check that everything is working properly
`ssh ubuntu@[MASTER_IP] -i ../secrets/ssh-user -o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q -i ../secrets/ssh-user ubuntu@[BASTION_IP]"`

> the IPs for master node and bastion can be foundn in _ansible/hosts.init_

run `sudo su`
run `kubectl get node --kubeconfig /etc/kubernetes/admin.conf`

the output should look like

```
NAME                                          STATUS     ROLES    AGE     VERSION
ip-10-100-10-20.eu-west-1.compute.internal    NotReady   master   10m     v1.15.5
ip-10-100-11-138.eu-west-1.compute.internal   NotReady   master   9m46s   v1.15.5
ip-10-100-12-221.eu-west-1.compute.internal   NotReady   master   10m     v1.15.5
ip-10-100-11-121.eu-west-1.compute.internal   NotReady   infra    1m      v1.15.5
```

> the status is _NotReady_ because the CNI is not yet configured, but seeing the nodes is enough to prove we are good to continue

---

## prepare openpnv playbook

In order to communicate with the bastions and the nodes securely we setup a VPN

create playbook to setup openvpn

```
cat <<-EOF > ansible/openvpn.yml
- name: Installing and configuring openvpn certificate via furyagent
  hosts: bastion
  become: true
  vars:
    furyagent_configure_openvpn: true
  vars_files:
    - '../secrets/fury.yml'
  roles:
    - aws/furyagent

- name: Provisioning bastion hosts
  hosts: bastion
  become: true
  vars:
    openvpn_dns_servers:
      - "{{ dns_server }}"
    openvpn_remote_servers: "{{ groups['bastion'] | map('extract', hostvars, ['ansible_host']) | list }}"
    openvpn_client_config_local_dir: ../secrets/users/openvpn
    openvpn_users:
      - openvpn-user
  roles:
    - openvpn/openvpn
EOF
```

---

## run openpnv playbook

run `ansible-playbook openvpn.yml`

> this commands will create two files _secrets/users/openvpn/openvpn-user.conf_ and _secrets/openvpn-furyagent.yml_

---

## prepare furyagent to create vpn certificates

inside _secrets/openvpn-furyagent.yml_

add user to the list `clusterComponent.openvpn-client.users`

in the end it should like this

> openvpn-user is the same name used in _ansible/openvpn.yml_

```
storage:
  provider: s3
  url: 'http://s3-eu-west-1.amazonaws.com'
  aws_access_key: 'xxx'
  aws_secret_key: 'xxx'
  bucketName: 'sighup-try-aws-test-agent'
  region: 'eu-west-1'
clusterComponent:
  nodeName: ip-10-100-0-65
  openvpn:
    certDir: /etc/openvpn/pki
  openvpn-client:
    targetDir: ./secrets/openvp-clients
    users:
      - openvpn-user

```

---

## create vpn configurations

while in _ansible_ folder

run `furyagent configure openvpn-client --config ../secrets/openvpn-furyagent.yml`

---

## install the VPN on your local machine

install the vpn using the configuration found in _secrets/users/openvpn/openvpn-user/openvpn-user.conf_
following your tool instructions

for macos users using [tunnelblick](https://tunnelblick.net/cConfigT.html) the section **If you already have configuration file** shows the required steps

### Checkpoint

From now on you will be able to reach the nodes when running the VPN from your local machine

example command:
`kubectl --kubeconfig=secrets/users/admin.conf get nodes`

---

## prepare for using kustomize

create manifestes folders to hold k8s manifests files for _kustomize_

in the project root run

```
cat <<-EOF > manifests/kustomization.yaml
bases:
EOF
```

---

## installing a CNI

install weave-net in k8s cluster

add to _manifests/kustomization.yaml_ in `bases`

```
- ../vendor/katalog/networking/weave-net
```

run `kustomize build manifests | kubectl apply -f - --kubeconfig=secrets/users/admin.conf` to deploy

> if you encounter this error, this is expected, not need to worry about
> `error: unable to recognize "STDIN": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"`

---

### checkpoint

at this point the cluster is setup with
2 bastion
3 master nodes running control _plane inside_ pods managed by k8s except for _etcd_ which runs under _systemd_
1 infra node

every machine is accessible by it's IP using then VPN (IPs are found in _ansible/hosts.ini_)

---

## Nest steps:

### install storage

install storage class for ebs in k8s cluster

add to _manifests/kustomization.yml_ in `bases`

```
- ../vendor/katalog/aws/storageclass
```

run `kustomize build manifests | kubectl apply -f - --kubeconfig=secrets/users/admin.conf` to deply

---

### FAQ

Q: where is cluster state stored?
A: the state of the cluster if manager by terraform and stored in a bucket on s3

Q: how can i use _kubectl_?
A: while the vpn is active, using `kubectl --kubeconfig=./secrets/users/admin.conf [command_here]` will send the command to a master node

## Teardown

to remove all resources created by **terraform**, run `make destroy` inside the _terrafom_ folder
