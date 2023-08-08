# Fury EKS Addons Example

This folder contains working examples of the terraform module `eks-addons`.

In order to test it, you follow the instructions below.
Note all comments starting with `TASK:` require you to run some manual action on your computer
that cannot be automated with the following script.

Note: this module requires an existing EKS cluster to be executed.
You may want to have a look at this [example](https://github.com/sighupio/fury-eks-installer/blob/main/examples/README.md).

```bash
# First of all, export the needed env vars for the aws provider to work
export AWS_ACCESS_KEY_ID=<YOUR_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<YOUR_SECRET_ACCESS_KEY>
export AWS_REGION=<YOUR_REGION>

# Bring up the addons
cd examples/eks-addons
cp main.auto.tfvars.dist main.auto.tfvars
# TASK: fill in main.auto.tfvars with your data
terraform init
terraform apply

```
