# Fury Amazon AMIs

[![Build Status](http://ci.sighup.io/api/badges/sighupio/fury-kubernetes-aws/status.svg)](http://ci.sighup.io/sighupio/fury-kubernetes-aws)

Fury Kubernetes Distribution uses custom AMI's based on Ubuntu to run in a proper and consistent way.

## Base image

All the AMI's are based on LTS Ubuntu version, currently 18.04.

## AMI kinds

Fury distributes three different AMI types: *Master*, *Node* and *Bastion*.

### Master

Contains all the necessary configuration and packages to make it work with a specific Kubernetes version.

### Node

Contains all the necessary configuration and packages to make it work with a specific Kubernetes version. Auto-join feature is active in this AMI.

### Bastion

Contains only furyagent installed.

## AMI IDs

| Name                                      | Fury Version | AMI                   | Region       | Kind    |
|-------------------------------------------|--------------|-----------------------|--------------|---------|
| KFD-Ubuntu-Master-1.15.5-1-1581355187     | 1.15.5-1     | ami-0ac7eb7739bc8085c | eu-central-1 | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1581355187       | 1.15.5-1     | ami-0e20132ae486749ea | eu-central-1 | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1581355186    | 1.15.5-1     | ami-0708eab96604b7fa0 | eu-central-1 | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1581355187     | 1.15.5-1     | ami-0e9dde6cae958f99f | eu-north-1   | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1581355187       | 1.15.5-1     | ami-0e38f44005f5d4421 | eu-north-1   | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1581355186    | 1.15.5-1     | ami-0999d1a2e61a33d47 | eu-north-1   | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1581355187     | 1.15.5-1     | ami-0ffb9e5e3b4eed197 | eu-west-1    | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1581355187       | 1.15.5-1     | ami-017460cc6c311beaa | eu-west-1    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1581355186    | 1.15.5-1     | ami-0b2c2468c1551a1e1 | eu-west-1    | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1581355187     | 1.15.5-1     | ami-030ea11676afe5ddf | eu-west-2    | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1581355187       | 1.15.5-1     | ami-0517c2c1a36d92b54 | eu-west-2    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1581355186    | 1.15.5-1     | ami-003c57e604c3c50af | eu-west-2    | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1581355187     | 1.15.5-1     | ami-06db857d66a601604 | eu-west-3    | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1581355187       | 1.15.5-1     | ami-0124e916dfca6664c | eu-west-3    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1581355186    | 1.15.5-1     | ami-0d5132a99dab8c7de | eu-west-3    | Bastion |
