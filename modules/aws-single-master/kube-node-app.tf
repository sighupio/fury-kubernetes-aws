resource "aws_launch_configuration" "k8s-app-nodes" {
  name_prefix = "${var.cluster_name}-${var.environment}-k8s-app-nodes"
  image_id = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.kube_app_node_type}"
  key_name = "${aws_key_pair.kube-key.id}"
  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.name}"
  security_groups = ["${aws_security_group.kubernetes-nodes.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_device_size}"
    delete_on_termination = "true"
  }

  # ebs_block_device {
  #   device_name = "${var.docker_device_name}"
  #   volume_type = "gp2"
  #   volume_size = "${var.docker_device_size}"
  #   delete_on_termination = "true"
  # }
}

resource "aws_autoscaling_group" "k8s-app-nodes" {
  name = "${var.cluster_name}-${var.environment}-k8s-app-asg"
  vpc_zone_identifier = ["${flatten(aws_subnet.kube-subnet.*.id)}"]
  desired_capacity = "${var.kube_app_node_count}"
  max_size = "${var.kube_app_node_count}"
  min_size = "${var.kube_app_node_count}"
  launch_configuration = "${aws_launch_configuration.k8s-app-nodes.name}"

  tags = [
    {
      key = "Role"
      value = "node"
      propagate_at_launch = "true"
    },
    {
      key = "Type"
      value = "app"
      propagate_at_launch = "true"
    },
    {
      key = "KubernetesCluster"
      value = "${var.cluster_name}"
      propagate_at_launch = "true"
    }
  ]
}

data "aws_instances" "app-nodes" {

  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = ["${aws_autoscaling_group.k8s-app-nodes.id}"]
  }

  instance_state_names = [ "running" ]
  depends_on = ["aws_autoscaling_group.k8s-nodes"]
}
