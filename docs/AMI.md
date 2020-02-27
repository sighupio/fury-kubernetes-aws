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
| KFD-Ubuntu-Master-1.15.5-1-1582820289     | 1.15.5-2     | ami-031ee8bc9d3b323f9 | eu-central-1 | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1582820290       | 1.15.5-2     | ami-0262d2acf5fc18b5e | eu-central-1 | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1582820289    | 1.15.5-2     | ami-03d700a7de9eb9224 | eu-central-1 | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1582820289     | 1.15.5-2     | ami-090de968442ffcda8 | eu-north-1   | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1582820290       | 1.15.5-2     | ami-0875d4afb4e5a7cfd | eu-north-1   | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1582820289    | 1.15.5-2     | ami-05c1d1e6f15b3b0fa | eu-north-1   | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1582820289     | 1.15.5-2     | ami-07ed4f381deed4e35 | eu-west-1    | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1582820290       | 1.15.5-2     | ami-09b1d72cd2d016383 | eu-west-1    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1582820289    | 1.15.5-2     | ami-00f09e08869a92610 | eu-west-1    | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1582820289     | 1.15.5-2     | ami-047e0be62d4706dfa | eu-west-2    | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1582820290       | 1.15.5-2     | ami-0ab27f084b46ac07c | eu-west-2    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1582820289    | 1.15.5-2     | ami-0f3f7e32dc4d2e6ff | eu-west-2    | Bastion |
| KFD-Ubuntu-Master-1.15.5-1-1582820289     | 1.15.5-2     | ami-0bae38b98c539bc6d | eu-west-3    | Master  |
| KFD-Ubuntu-Node-1.15.5-1-1582820290       | 1.15.5-2     | ami-0390faa17735d4b05 | eu-west-3    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-1-1582820289    | 1.15.5-2     | ami-0d6c648fbd61b89c4 | eu-west-3    | Bastion |
