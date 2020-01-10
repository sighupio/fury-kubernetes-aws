module "acm-certificate" {
  source                            = "acm-certificate"
  count                             = "${length(var.acms_config_list)}"
  domain_name                       = "${lookup(var.acm_domain_name[count.index],"acm_domain_name")}"
  sans_with_same_domain             = "${split(",",lookup(var.acm_domain_name[count.index],"sans_with_same_domain"))"}"
  validation_ttl                    = "${lookup(var.acm_domain_name[count.index],"validation_ttl")}"
  public_hosted_zone_id             = "${lookup(var.acm_domain_name[count.index],"hosted_zone_id")}"
  allow_validation_record_overwrite = "${lookup(var.acm_domain_name[count.index],"allow_validation_record_overwrite")}"
}
