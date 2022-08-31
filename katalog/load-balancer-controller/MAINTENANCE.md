# Load Balancer controller maintenance

To maintain the aws load balancer controller package, you should follow this steps.

Go to https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/deploy/installation/ and follow the steps for
the non-helm installation.

Get the yaml file, for example https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.3/v2_4_3_full.yaml
and compare it with `deploy.yaml` file.

What was changed:
- Changed the image with the images synchronized with registry.sighup.io
- Moved cluster name to an environment variable `CLUSTER_NAME`