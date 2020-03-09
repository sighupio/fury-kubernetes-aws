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
| KFD-Ubuntu-Master-1.15.5-3-1583752866     | 1.15.5-3     | ami-045e1eaec25c8e414 | eu-central-1 | Master  |
| KFD-Ubuntu-Node-1.15.5-3-1583752867       | 1.15.5-3     | ami-00c5b94e5dbee1b3f | eu-central-1 | Node    |
| KFD-Ubuntu-Bastion-1.15.5-3-1583752866    | 1.15.5-3     | ami-051f7ee80bff36f7e | eu-central-1 | Bastion |
| KFD-Ubuntu-Master-1.15.5-3-1583752866     | 1.15.5-3     | ami-0937ced55e3d30d9b | eu-north-1   | Master  |
| KFD-Ubuntu-Node-1.15.5-3-1583752867       | 1.15.5-3     | ami-096f4ee06c7537e10 | eu-north-1   | Node    |
| KFD-Ubuntu-Bastion-1.15.5-3-1583752866    | 1.15.5-3     | ami-0a0e65c6ab4b29960 | eu-north-1   | Bastion |
| KFD-Ubuntu-Master-1.15.5-3-1583752866     | 1.15.5-3     | ami-018bae9cccbcd3ed6 | eu-west-1    | Master  |
| KFD-Ubuntu-Node-1.15.5-3-1583752867       | 1.15.5-3     | ami-080da29be546fd5d6 | eu-west-1    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-3-1583752866    | 1.15.5-3     | ami-07e8420dcdd4bf670 | eu-west-1    | Bastion |
| KFD-Ubuntu-Master-1.15.5-3-1583752866     | 1.15.5-3     | ami-07728870b709948f8 | eu-west-2    | Master  |
| KFD-Ubuntu-Node-1.15.5-3-1583752867       | 1.15.5-3     | ami-0fca583b687e60de2 | eu-west-2    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-3-1583752866    | 1.15.5-3     | ami-07f77e91e0636cd4c | eu-west-2    | Bastion |
| KFD-Ubuntu-Master-1.15.5-3-1583752866     | 1.15.5-3     | ami-0ba3226228c7a73cc | eu-west-3    | Master  |
| KFD-Ubuntu-Node-1.15.5-3-1583752867       | 1.15.5-3     | ami-00a675e79fbb002a5 | eu-west-3    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-3-1583752866    | 1.15.5-3     | ami-08450640073abb3eb | eu-west-3    | Bastion |
