resource "aws_launch_template" "spot" {
  count         = "${length(var.kube-workers-spot)}"
  name_prefix   = "${var.name}-${var.env}-k8s-${lookup(var.kube-workers-spot[count.index], "kind")}-nodes"
  image_id      = "${element(data.aws_ami.spot.*.id, count.index)}"
  instance_type = "${lookup(var.kube-workers-spot[count.index], "type")}"
  user_data     = "${element(data.template_cloudinit_config.config_spot.*.rendered, count.index)}"

  iam_instance_profile {
    name = "${aws_iam_instance_profile.main.name}"
  }

  network_interfaces {
    security_groups = ["${aws_security_group.kubernetes-nodes.id}"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "spot" {
  count                = "${length(var.kube-workers-spot)}"
  name                 = "${var.name}-${var.env}-k8s-${lookup(var.kube-workers-spot[count.index], "kind")}-asg"
  vpc_zone_identifier  = ["${flatten(data.aws_subnet.private.*.id)}"]
  desired_capacity     = "${lookup(var.kube-workers-spot[count.index], "desired")}"
  max_size             = "${lookup(var.kube-workers-spot[count.index], "max")}"
  min_size             = "${lookup(var.kube-workers-spot[count.index], "min")}"
  termination_policies = ["OldestInstance"]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${element(aws_launch_template.spot.*.id,count.index)}"
        version            = "${element(aws_launch_template.spot.*.latest_version,count.index)}"
      }

      override {
        instance_type = "${lookup(var.kube-workers-spot[count.index], "type")}"
      }

      override {
        instance_type = "${lookup(var.kube-workers-spot[count.index], "type_secondary")}"
      }
    }

    instances_distribution {
      on_demand_base_capacity                  = "0"
      on_demand_percentage_above_base_capacity = "0"
    }
  }

  tags = [
    {
      key                 = "Name"
      value               = "kube-node-${var.name}-${var.env}-${lookup(var.kube-workers-spot[count.index], "kind")}-asg"
      propagate_at_launch = "true"
    },
    {
      key                 = "Role"
      value               = "node"
      propagate_at_launch = "true"
    },
    {
      key                 = "Type"
      value               = "${lookup(var.kube-workers-spot[count.index], "kind")}"
      propagate_at_launch = "true"
    },
    {
      key                 = "KubernetesCluster"
      value               = "${var.name}-${var.env}"
      propagate_at_launch = "true"
    },
    {
      key                 = "KubernetesClusterAndType"
      value               = "${lookup(var.kube-workers-spot[count.index], "kind")}-${var.name}-${var.env}"
      propagate_at_launch = "true"
    },
    {
      key                 = "k8s.io/cluster-autoscaler/node-template/label/${var.node-role-tag-cluster-autoscaler}/${lookup(var.kube-workers-spot[count.index], "kind")}"
      value               = ""
      propagate_at_launch = "true"
    },
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["desired_capacity"]
  }
}
