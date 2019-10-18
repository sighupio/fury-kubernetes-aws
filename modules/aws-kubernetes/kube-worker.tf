resource "aws_launch_configuration" "main" {
  count                = "${length(var.kube-workers)}"
  name_prefix          = "${var.name}-${var.env}-k8s-${lookup(var.kube-workers[count.index], "kind")}-nodes"
  image_id             = "${element(data.aws_ami.worker.*.id, count.index)}"
  instance_type        = "${lookup(var.kube-workers[count.index], "type")}"
  user_data            = "${element(data.template_cloudinit_config.config_worker.*.rendered, count.index)}"
  iam_instance_profile = "${aws_iam_instance_profile.main.name}"
  security_groups      = ["${aws_security_group.kubernetes-nodes.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "80"
    delete_on_termination = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  count                = "${length(var.kube-workers)}"
  name                 = "${var.name}-${var.env}-k8s-${lookup(var.kube-workers[count.index], "kind")}-asg"
  vpc_zone_identifier  = ["${flatten(data.aws_subnet.private.*.id)}"]
  desired_capacity     = "${lookup(var.kube-workers[count.index], "count")}"
  max_size             = "${lookup(var.kube-workers[count.index], "count")}"
  min_size             = "${lookup(var.kube-workers[count.index], "count")}"
  launch_configuration = "${element(aws_launch_configuration.main.*.name, count.index)}"

  tags = [
    {
      key                 = "Role"
      value               = "node"
      propagate_at_launch = "true"
    },
    {
      key                 = "Type"
      value               = "${lookup(var.kube-workers[count.index], "kind")}"
      propagate_at_launch = "true"
    },
    {
      key                 = "KubernetesCluster"
      value               = "${var.name}-${var.env}"
      propagate_at_launch = "true"
    },
  ]

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_instances" "main" {
  count = "${length(var.kube-workers)}"

  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["${element(aws_autoscaling_group.main.*.id, count.index)}"]
  }

  instance_state_names = ["running"]
  depends_on           = ["aws_autoscaling_group.main"]
}

data "aws_autoscaling_groups" "infra" {
  filter {
    name   = "key"
    values = ["Type"]
  }

  filter {
    name   = "value"
    values = ["infra"]
  }
}
