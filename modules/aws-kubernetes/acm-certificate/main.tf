## acm certificate request
resource "aws_acm_certificate" "main" {
  domain_name               = "${var.domain_name}"
  validation_method         = "DNS"
  subject_alternative_names = "${var.sans_with_same_domain}"
  lifecycle  {
    create_before_destroy = true
  }
}

## acm certificate records for validation
resource "aws_route53_record" "main" {
  count                             = "${lenght(aws_acm_certificate.main.domain_validation_options)}"
  depends_on                        = ["aws_acm_certificate.main"]
  name                              = "${lookup(aws_acm_certificate.main.domain_validation_options[count.index], "resource_record_name")}"
  type                              = "${lookup(aws_acm_certificate.main.domain_validation_options[count.index], "resource_record_type")}"
  zone_id                           = "${var.acm_zone_id}"
  records                           = ["${lookup(aws_acm_certificate.main.domain_validation_options[count.index], "resource_record_value")}"]
  ttl                               = "${var.validation_ttl}"
  allow_validation_record_overwrite = "${var.aws_acm_certificate_validation}"

  lifecycle {
    create_before_destroy = true
  }
}

## acm certificate validation
resource "aws_acm_certificate_validation" "main" {
  depends_on              = ["aws_route53_record.main", "aws_acm_certificate.main"]
  certificate_arn         = "${aws_acm_certificate.main.arn}"
  validation_record_fqdns = ["${aws_route53_record.main.fqdn}"]

  lifecycle {
    create_before_destroy = true
  }
}
