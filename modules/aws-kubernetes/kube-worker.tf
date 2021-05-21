resource "aws_launch_configuration" "main" {
  count         = length(var.kube-workers)
  name_prefix   = "${var.name}-${var.env}-k8s-${var.kube-workers[count.index]["kind"]}-nodes"
  image_id      = element(data.aws_ami.worker.*.id, count.index)
  instance_type = var.kube-workers[count.index]["type"]
  user_data = element(
    data.template_cloudinit_config.config_worker.*.rendered,
    count.index,
  )
  iam_instance_profile = aws_iam_instance_profile.main.name
  security_groups      = [aws_security_group.kubernetes-nodes.id]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = var.kube-workers[count.index]["disk"]
    delete_on_termination = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  count                = length(var.kube-workers)
  name                 = "${var.name}-${var.env}-k8s-${var.kube-workers[count.index]["kind"]}-asg"
  vpc_zone_identifier  = data.aws_subnet.private.*.id
  desired_capacity     = var.kube-workers[count.index]["desired"]
  max_size             = var.kube-workers[count.index]["max"]
  min_size             = var.kube-workers[count.index]["min"]
  launch_configuration = element(aws_launch_configuration.main.*.name, count.index)
  termination_policies = ["OldestInstance"]

  tags = [
    {
      key                 = "Name"
      value               = "kube-node-${var.name}-${var.env}-${var.kube-workers[count.index]["kind"]}-asg"
      propagate_at_launch = "true"
    },
    {
      key                 = "Role"
      value               = "node"
      propagate_at_launch = "true"
    },
    {
      key                 = "Type"
      value               = var.kube-workers[count.index]["kind"]
      propagate_at_launch = "true"
    },
    {
      key                 = "KubernetesCluster"
      value               = "${var.name}-${var.env}"
      propagate_at_launch = "true"
    },
    {
      key                 = "KubernetesClusterAndType"
      value               = "${var.kube-workers[count.index]["kind"]}-${var.name}-${var.env}"
      propagate_at_launch = "true"
    },
    {
      key                 = "k8s.io/cluster-autoscaler/node-template/label/${var.node-role-tag-cluster-autoscaler}/${var.kube-workers[count.index]["kind"]}"
      value               = "ignored"
      propagate_at_launch = "true"
    },
  ]

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

data "aws_autoscaling_groups" "infra" {
  filter {
    name   = "key"
    values = ["KubernetesClusterAndType"]
  }

  filter {
    name   = "value"
    values = ["infra-${var.name}-${var.env}"]
  }
}

resource "aws_autoscaling_schedule" "workers_morning_start" {
  count                  = var.enable_weekday_workers_shutdown ? length(var.kube-workers) : 0
  scheduled_action_name  = "Morning-Start-Schedule"
  min_size               = var.kube-workers[count.index]["min"]
  max_size               = var.kube-workers[count.index]["max"]
  desired_capacity       = var.kube-workers[count.index]["desired"]
  recurrence             = "0 5 * * 1-5"
  autoscaling_group_name = element(aws_autoscaling_group.main.*.name, count.index)
}

resource "aws_autoscaling_schedule" "workers_afternoon_stop" {
  count                  = var.enable_weekday_workers_shutdown ? length(var.kube-workers-spot) : 0
  scheduled_action_name  = "Afternoon-Stop-Schedule"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "45 23 * * *"
  autoscaling_group_name = element(aws_autoscaling_group.main.*.name, count.index)
}
