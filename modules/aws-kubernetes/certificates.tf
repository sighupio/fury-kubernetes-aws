module "acm-certificate" {
  source                            = "acm-certificate"
  count                             = "${length(var.acms_config_list)}"
  domain_name                       = "${lookup(var.acms_config_list[count.index],"acm_domain_name")}"
  sans_with_same_domain             = "${split(",",lookup(var.acms_config_list[count.index],"sans_with_same_domain"))"}"
  validation_ttl                    = "${lookup(var.acms_config_list[count.index],"validation_ttl")}"
  public_hosted_zone_id             = "${lookup(var.acms_config_list[count.index],"public_hosted_zone_id")}"
  allow_validation_record_overwrite = "${lookup(var.acms_config_list[count.index],"allow_validation_record_overwrite")}"
}
