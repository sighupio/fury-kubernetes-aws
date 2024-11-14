# Load Balancer controller maintenance

To maintain the AWS load balancer controller package, you should follow these steps.

Go to <https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation/> and follow the steps for
the non-helm installation.

Get the yaml file, for example <https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.10.0/v2_10_0_full.yaml>
and compare it with `deploy.yaml` file.

What was changed:

- Moved cluster name to an environment variable `CLUSTER_NAME`
