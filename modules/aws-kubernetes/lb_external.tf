locals {
  access_log = {
    enabled = [
      {
        bucket  = "${var.name}-${var.env}-external-lb-logs"
        enabled = true
      },
    ]

    disabled = []
  }
}

resource "aws_lb" "external" {
  name                             = "${var.name}-${var.env}-external"
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = ["${flatten(data.aws_subnet.public.*.id)}"]
  security_groups                  = ["${aws_security_group.k8s-nodes.id}"]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
  idle_timeout                     = 400

  access_logs = ["${local.access_log[var.kube-lb-external-enable-access-log ? "enabled" : "disabled"]}"]

  tags {
    Name = "${var.name}-${var.env}-external"
    env  = "${var.env}"
  }
}

resource "aws_lb_listener" "k8s-nodes-http" {
  load_balancer_arn = "${aws_lb.external.arn}"
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

resource "aws_lb_listener" "k8s-nodes-https" {
  count             = "${length(var.kube-lb-external-domains) > 0 ? 1 : 0}"
  load_balancer_arn = "${aws_lb.external.arn}"
  port              = "443"
  protocol          = "HTTPS"

  // https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = "${element(data.aws_acm_certificate.main.*.arn, 0)}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.k8s-nodes.arn}"
  }
}

resource "aws_lb_listener_certificate" "main" {
  count           = "${length(var.kube-lb-external-domains) == 0 ? 0 : length(var.kube-lb-external-domains) - 1}"
  listener_arn    = "${aws_lb_listener.k8s-nodes-https.arn}"
  certificate_arn = "${element(data.aws_acm_certificate.main.*.arn, count.index + 1)}"
}

data "aws_acm_certificate" "main" {
  count       = "${length(var.kube-lb-external-domains)}"
  domain      = "${element(var.kube-lb-external-domains, count.index)}"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_target_group" "k8s-nodes" {
  name        = "${var.name}-${var.env}-k8s-nodes"
  port        = 31080
  protocol    = "HTTP"
  vpc_id      = "${data.aws_subnet.public.0.vpc_id}"
  target_type = "instance"

  health_check {
    path                = "/healthz"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "HTTP"
    port                = "31080"
  }
}

resource "aws_autoscaling_attachment" "k8s-nodes" {
  count                  = "${length(data.aws_autoscaling_groups.infra.names)}"
  autoscaling_group_name = "${element(data.aws_autoscaling_groups.infra.names, count.index)}"
  alb_target_group_arn   = "${aws_lb_target_group.k8s-nodes.arn}"
}

resource "aws_security_group" "k8s-nodes" {
  name   = "${var.name}-${var.env}-external-lb"
  vpc_id = "${data.aws_subnet.public.0.vpc_id}"

  tags {
    Name = "${var.name}-${var.env}-external-lb"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //allow everything in egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
