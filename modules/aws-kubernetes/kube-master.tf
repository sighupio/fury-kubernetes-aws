resource "aws_instance" "k8s-master" {
  count         = "${var.kube_master_count}"
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.kube_master_type}"
  key_name      = "${aws_key_pair.kube-key.id}"
  subnet_id     = "${element(aws_subnet.kube-subnet.*.id, count.index)}"

  iam_instance_profile = "${aws_iam_instance_profile.kubernetes.name}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes-master.id}"]

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

  tags {
    Name = "kube-master-${var.cluster_name}-${var.environment}-${count.index+1}"
    Role = "master"
    Gated = "true"
    KubernetesCluster = "${var.cluster_name}"
  }
}