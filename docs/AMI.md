# Fury Amazon AMIs

[![Build Status](http://ci.sighup.io/api/badges/sighupio/fury-kubernetes-aws/status.svg)](http://ci.sighup.io/sighupio/fury-kubernetes-aws)

Fury Kubernetes distribution uses custom AMI's based on Ubuntu to run in a proper way.

## Ubuntu based

All the AMI's are based on LTS Ubuntu version, currently 18.04.

## AMI kinds

Fury distributes three different AMI types: *Master*, *Node* and *Bastion*.

### Master

Contains all the necessary configuration to make it working with the specific kubernetes version.

### Node

Contains all the necessary configuration to make it working with the specific kubernetes version. Auto-join feature is active in this AMI.

### Bastion

Contains only furyagent installed.

## AMI IDs

| Name                                      | Fury Version | AMI                   | Region       | Kind    |
|-------------------------------------------|--------------|-----------------------|--------------|---------|
| KFD-Ubuntu-Master-1.15.5-2-1579779741     | 1.15.4-5     | ami-09405f10a0a6999ce | eu-central-1 | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1579779741       | 1.15.4-5     | ami-05494483088483273 | eu-central-1 | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1579779740    | 1.15.4-5     | ami-00b729abab1b2af46 | eu-central-1 | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1579779741     | 1.15.4-5     | ami-0949f1c78ef318fbe | eu-north-1   | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1579779741       | 1.15.4-5     | ami-0ff227891ed844760 | eu-north-1   | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1579779740    | 1.15.4-5     | ami-00b729abab1b2af46 | eu-north-1   | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1579779741     | 1.15.4-5     | ami-08e79902f55bbd13f | eu-west-1    | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1579779741       | 1.15.4-5     | ami-0cbba18efeef096f6 | eu-west-1    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1579779740    | 1.15.4-5     | ami-0f5e60c0a1e1f9ff5 | eu-west-1    | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1579779741     | 1.15.4-5     | ami-07362dc85fb207740 | eu-west-2    | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1579779741       | 1.15.4-5     | ami-09a8ae2a05f70b570 | eu-west-2    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1579779740    | 1.15.4-5     | ami-0bebf58296f86d308 | eu-west-2    | Bastion |
| KFD-Ubuntu-Master-1.15.5-2-1579779741     | 1.15.4-5     | ami-02a9d50b47c9b2fef | eu-west-3    | Master  |
| KFD-Ubuntu-Node-1.15.5-2-1579779741       | 1.15.4-5     | ami-0d3235975e9f3ae87 | eu-west-3    | Node    |
| KFD-Ubuntu-Bastion-1.15.5-2-1579779740    | 1.15.4-5     | ami-023651eb3e778c6fd | eu-west-3    | Bastion |
