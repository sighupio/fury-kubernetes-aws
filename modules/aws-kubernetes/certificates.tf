module "acm-certificate" {
  source             = "acm-certificate"
  domain_name        = "${var.acm_domain_name}"
  sans               = "${var.acm_sans}"
  hosted_zone_id     = "${var.kube_domain}"
}
