# Fury Amazon AMIs

[![Build Status](http://ci.sighup.io/api/badges/sighupio/fury-kubernetes-aws/status.svg)](http://ci.sighup.io/sighupio/fury-kubernetes-aws)

Fury Kubernetes distribution uses custom AMI's based on Ubuntu to run in a proper way.

## Ubuntu based

All the AMI's are based on LTS Ubuntu version, currently 18.04.

## AMI kinds

Fury distributes three different AMI types: *Master*, *Node* and *Bastion*.

### Master

Contains all the neccessary configuration to make it working with the specific kubernetes version.

### Node

Contains all the neccessary configuration to make it working with the specific kubernetes version. Auto-join feature is activated in this AMI.

### Bastion

Contains only furyagent installed.

## AMI IDs

| Name                                      | Fury Version | AMI                   | Region       | Kind    |
|-------------------------------------------|--------------|-----------------------|--------------|---------|
| KFD-Ubuntu-Master-1.15.5-2-1572436070     | 1.15.4-2     | ami-07bf0537ace102ba4 | eu-central-1 | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1572436071       | 1.15.4-2     | ami-026eaa3e3ca8827ce | eu-central-1 | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1572436070    | 1.15.4-2     | ami-0326230e05b7f29a8 | eu-central-1 | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1572436070     | 1.15.4-2     | ami-02100b6018d7b17c5 | eu-north-1   | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1572436071       | 1.15.4-2     | ami-06a1e980e801cc6f2 | eu-north-1   | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1572436070    | 1.15.4-2     | ami-0d8d6e2b63cd2f0be | eu-north-1   | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1572436070     | 1.15.4-2     | ami-0c3f77ab96e04e208 | eu-west-1    | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1572436071       | 1.15.4-2     | ami-02b3cd4c27a9c0139 | eu-west-1    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1572436070    | 1.15.4-2     | ami-0c4d3c3b952e38ee6 | eu-west-1    | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1572436070     | 1.15.4-2     | ami-081b37e491554ad36 | eu-west-2    | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1572436071       | 1.15.4-2     | ami-048dfff321b0f0dac | eu-west-2    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1572436070    | 1.15.4-2     | ami-03a696cd31c95d10a | eu-west-2    | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1572436070     | 1.15.4-2     | ami-055b703f134ba9c72 | eu-west-3    | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1572436071       | 1.15.4-2     | ami-0ac1df9ab2d92bba7 | eu-west-3    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1572436070    | 1.15.4-2     | ami-023651eb3e778c6fd | eu-west-3    | Bastion |
