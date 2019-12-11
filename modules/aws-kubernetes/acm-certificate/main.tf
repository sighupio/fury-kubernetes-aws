## acm certificate request
resource "aws_acm_certificate" "main" {
  domain_name               = "${var.domain_name}"
  subject_alternative_names = "${var.sans}"
  validation_method         = "DNS"

  lifecycle  {
    create_before_destroy = true
  }
}

## acm certificate records for validation
resource "aws_route53_record" "main-0" {
  depends_on = ["aws_acm_certificate.main"]
  name       = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_name}"
  type       = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_type}"
  zone_id    = "${var.acm_zone_id}"
  records    = ["${aws_acm_certificate.main.domain_validation_options.0.resource_record_value}"]
  ttl        = 60

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "main-1" {
  depends_on = ["aws_acm_certificate.main"]
  name       = "${aws_acm_certificate.main.domain_validation_options.1.resource_record_name}"
  type       = "${aws_acm_certificate.main.domain_validation_options.1.resource_record_type}"
  zone_id    = "${var.acm_zone_id}"
  records    = ["${aws_acm_certificate.main.domain_validation_options.1.resource_record_value}"]
  ttl        = 60

  lifecycle {
    create_before_destroy = true
  }
}


## acm certificate validation
resource "aws_acm_certificate_validation" "main-validation" {
  depends_on              = ["aws_route53_record.main-validation", "aws_acm_certificate.main-validation"]
  certificate_arn         = "${aws_acm_certificate.main-validation.arn}"
  validation_record_fqdns = ["${aws_route53_record.main-validation.fqdn}"]

  lifecycle {
    create_before_destroy = true
  }
}
