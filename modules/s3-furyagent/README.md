# aws-ark

This module is useful to create all the things necessary for furyagent to work
and to be provisioned.

# Usage
```hcl
module "aws-furyagent" {
    source = "../vendor/modules/aws-furyagent"
    cluster_name = "sighup"
    environment = "production"
    aws_region = "eu-west-1"
    furyagent_bucket_name = "sighup-backup"
}
```
