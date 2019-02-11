resource "aws_lb" "k8s-master" {
  name               = "${var.cluster_name}-${var.environment}-master-a"
  internal           = false
  load_balancer_type = "network"
  subnets             = ["${flatten(aws_subnet.public-subnet.*.id)}"]
  enable_deletion_protection = false
  enable_cross_zone_load_balancing   = false
  idle_timeout = 400
  tags {
    Name = "${var.cluster_name}-${var.environment}-master-alb"
    Environment = "production"
  }
}

resource "aws_lb_target_group" "k8s-master" {
  name     = "k8s-master"
  port     = 6443
  protocol = "TCP"
  vpc_id   = "${aws_vpc.kube-vpc.id}"
  target_type = "instance"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    protocol            = "TCP"
    port                = "6443"
  }
}

resource "aws_lb_listener" "k8s-master" {
  load_balancer_arn = "${aws_lb.k8s-master.arn}"
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.k8s-master.arn}"
  }
}

resource "aws_lb_target_group_attachment" "k8s-master" {
  target_group_arn = "${aws_lb_target_group.k8s-master.arn}"
  target_id        = "${aws_instance.k8s-master.id}"
}
