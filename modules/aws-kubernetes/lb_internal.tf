resource "aws_lb" "internal" {
  name                             = "${var.name}-${var.env}-internal"
  internal                         = true
  load_balancer_type               = "network"
  subnets                          = ["${flatten(data.aws_subnet.public.*.id)}"]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
  idle_timeout                     = 400

  tags {
    Name        = "${var.name}-${var.env}-internal"
    Environment = "${var.env}"
  }
}

resource "aws_lb_target_group" "k8s-master" {
  name        = "${var.name}-${var.env}-k8s-master"
  port        = 6443
  protocol    = "TCP"
  vpc_id      = "${data.aws_subnet.public.0.vpc_id}"
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "TCP"
    port                = 6443
  }
}

resource "aws_lb_listener" "k8s-master" {
  load_balancer_arn = "${aws_lb.internal.arn}"
  port              = 6443
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.k8s-master.arn}"
  }
}

resource "aws_lb_target_group_attachment" "k8s-master" {
  count            = "${var.kube-master-count}"
  target_group_arn = "${aws_lb_target_group.k8s-master.arn}"
  target_id        = "${element(aws_instance.k8s-master.*.id, count.index)}"
}

resource "aws_lb_target_group" "internal-ingress" {
  name        = "${var.name}-${var.env}-internal-ingress"
  port        = 32080
  protocol    = "TCP"
  vpc_id      = "${data.aws_subnet.public.0.vpc_id}"
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "TCP"
    port                = 32080
  }
}

resource "aws_lb_listener" "internal-ingress" {
  load_balancer_arn = "${aws_lb.internal.arn}"
  port              = 32080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.internal-ingress.arn}"
  }
}

resource "aws_autoscaling_attachment" "internal-ingress" {
  count                  = "${length(var.kube-workers)}"
  autoscaling_group_name = "${element(aws_autoscaling_group.main.*.id, count.index)}"
  alb_target_group_arn   = "${aws_lb_target_group.internal-ingress.arn}"
}

resource "aws_route53_record" "master-lb" {
  zone_id = "${var.kube-domain}"
  name    = "master"
  type    = "A"

  alias {
    name                   = "${aws_lb.internal.dns_name}"
    zone_id                = "${aws_lb.internal.zone_id}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "internal" {
  count   = "${length(var.kube-lb-internal-domains)}"
  zone_id = "${var.kube-domain}"
  name    = "${element(var.kube-lb-internal-domains, count.index)}"
  type    = "A"

  alias {
    name                   = "${aws_lb.internal.dns_name}"
    zone_id                = "${aws_lb.internal.zone_id}"
    evaluate_target_health = true
  }
}
