# ACM AWS Module

the module is intended to handle the creation, DNS challange and appproval of the acm as well.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| zone_id| The public zone id in which lookup for dns entries for dns challange. | `string` | `""` | yes |
| domain_name | The domain name for the acm | `string` | `""` | yes |
| sans_with_same_domain | A list of the subject alternative names to add to the generation of the domain_name | `list(string)` | `[]` | no |
| validation_ttl | The ttl time of the record fqdns that are checked from the validation process  | `string` | `"600"` | no |
| allow_validation_record_overwrite | Whether or not overwrite an already existing route53 records | `bool` | `false` | yes |



```hcl
module "acm-certificate-example-com" {
source = "acm-certificate"
zone_id = "\${module.public-zones.example_com_zone_id}"
domain_name = "example.com"
sans_with_same_domain = ["*.example.com"]
validation_ttl = 60
allow_validation_record_overwrite = true
}
```

Due to a bug that is handled in terraform 2.x, the resource will give an error at the first apply, so it will be necessary a second run : https://github.com/hashicorp/terraform/issues/9858