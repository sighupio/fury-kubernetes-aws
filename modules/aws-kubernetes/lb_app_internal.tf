resource "aws_lb" "internal-http" {
  name                             = "${var.name}-${var.env}-int-http"
  internal                         = true
  load_balancer_type               = "application"
  subnets                          = ["${flatten(data.aws_subnet.public.*.id)}"]
  security_groups                  = ["${aws_security_group.k8s-nodes.id}"]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
  idle_timeout                     = 400

  tags {
    Name = "${var.name}-${var.env}-int-http"
    env  = "${var.env}"
  }
}

resource "aws_lb_listener" "k8s-nodes-http-internal" {
  load_balancer_arn = "${aws_lb.internal-http.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

data "aws_acm_certificate" "internal" {
  count       = "${length(var.kube-lb-internal-additional-domains)}"
  domain      = "${element(formatlist("%s.%s", var.kube-lb-internal-additional-domains, replace(data.aws_route53_zone.additional.0.name, "/[.]$/", "")), count.index)}"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "k8s-nodes-https-internal" {
  count             = "${length(var.kube-lb-internal-additional-domains) > 0 ? 1 : 0}"
  load_balancer_arn = "${aws_lb.internal-http.arn}"
  port              = "443"
  protocol          = "HTTPS"

  // https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = "${element(data.aws_acm_certificate.internal.*.arn, 0)}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.k8s-nodes-internal.arn}"
  }
}

resource "aws_lb_listener_certificate" "internal-http" {
  count           = "${length(var.kube-lb-internal-additional-domains) == 0 ? 0 : length(var.kube-lb-internal-additional-domains) - 1}"
  listener_arn    = "${aws_lb_listener.k8s-nodes-https-internal.arn}"
  certificate_arn = "${element(data.aws_acm_certificate.internal.*.arn, count.index + 1)}"
}

resource "aws_lb_target_group" "k8s-nodes-internal" {
  name        = "${var.name}-${var.env}-k8s-nodes-int"
  port        = 32080
  protocol    = "HTTP"
  vpc_id      = "${data.aws_subnet.public.0.vpc_id}"
  target_type = "instance"

  health_check {
    path                = "/healthz"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "HTTP"
    port                = "32080"
  }
}

resource "aws_autoscaling_attachment" "k8s-nodes-internal" {
  count                  = "${length(data.aws_autoscaling_groups.infra.names)}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.infra.names, count.index)}"
  alb_target_group_arn   = "${aws_lb_target_group.k8s-nodes-internal.arn}"
}

resource "aws_route53_record" "additional" {
  count   = "${length(var.kube-lb-internal-additional-domains)}"
  zone_id = "${var.additional-domain}"
  name    = "${element(var.kube-lb-internal-additional-domains, count.index)}"
  type    = "A"

  alias {
    name                   = "${aws_lb.internal-http.dns_name}"
    zone_id                = "${aws_lb.internal-http.zone_id}"
    evaluate_target_health = true
  }
}
