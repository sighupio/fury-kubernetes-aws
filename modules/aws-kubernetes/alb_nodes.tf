resource "aws_lb" "k8s-nodes" {
  name                             = "${var.name}-${var.env}-nodes-a"
  internal                         = false
  load_balancer_type               = "application"
  subnets                          = ["${flatten(data.aws_subnet.public.*.id)}"]
  security_groups                  = ["${aws_security_group.k8s-nodes.id}"]
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
  idle_timeout                     = 400

  tags {
    Name  = "${var.name}-${var.env}-nodes-alb"
    env   = "production"
  }
}

resource "aws_lb_listener" "k8s-nodes-http" {
  load_balancer_arn = "${aws_lb.k8s-nodes.arn}"
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
  count       = "${length(var.kube-lb-external-domains)}"
  load_balancer_arn = "${aws_lb.k8s-nodes.arn}"
  port              = "443"
  protocol          = "HTTPS"

  // https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html
  ssl_policy      = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn = "${element(data.aws_acm_certificate.certificate.*.arn, count.index)}"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.k8s-nodes.arn}"
  }
}


//look for aws_lb_listener_certificate
data "aws_acm_certificate" "certificate" {
  count       = "${length(var.kube-lb-external-domains)}"
  domain      = "${var.kube-lb-external-domains[count.index]}"
  statuses    = ["ISSUED"]
  most_recent = true
}

resource "aws_lb_target_group" "k8s-nodes" {
  name        = "k8s-nodes"
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
  count                  = "${length(var.kube-workers)}"
  autoscaling_group_name = "${element(aws_autoscaling_group.main.*.name, count.index)}"
  alb_target_group_arn   = "${aws_lb_target_group.k8s-nodes.arn}"
}

resource "aws_security_group" "k8s-nodes" {
  name        = "${var.name}-${var.env}-web"
  vpc_id      = "${data.aws_subnet.public.0.vpc_id}"

  tags {
    Name = "${var.name}-k8s-elb-${var.env}-web"
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
