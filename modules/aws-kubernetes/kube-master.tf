resource "aws_instance" "k8s-master" {
  count                  = "${var.kube-master-count}"
  ami                    = "${data.aws_ami.master.id}"
  instance_type          = "${var.kube-master-type}"
  user_data              = "${data.template_cloudinit_config.config_master.rendered}"
  subnet_id              = "${element(var.kube-private-subnets, count.index)}"
  iam_instance_profile   = "${aws_iam_instance_profile.main.name}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes-master.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "80"
    delete_on_termination = "true"
  }

  tags {
    Name              = "kube-master-${var.name}-${var.env}-${count.index + 1}"
    Role              = "master"
    Gated             = "true"
    KubernetesCluster = "${var.name}-${var.env}"
  }
}

resource "aws_volume_attachment" "k8s-master" {
  count       = "${length(var.kube-master-volumes) * var.kube-master-count}"
  device_name = "${lookup(var.kube-master-volumes[(count.index / var.kube-master-count) % length(var.kube-master-volumes)], "device_name")}"
  instance_id = "${element(aws_instance.k8s-master.*.id, count.index % var.kube-master-count)}"
  volume_id   = "${element(aws_ebs_volume.k8s-master.*.id, count.index)}"
}

resource "aws_ebs_volume" "k8s-master" {
  count             = "${length(var.kube-master-volumes) * var.kube-master-count}"
  size              = "${lookup(var.kube-master-volumes[(count.index / var.kube-master-count) % length(var.kube-master-volumes)], "size")}"
  type              = "${lookup(var.kube-master-volumes[(count.index / var.kube-master-count) % length(var.kube-master-volumes)], "type")}"
  iops              = "${lookup(var.kube-master-volumes[(count.index / var.kube-master-count) % length(var.kube-master-volumes)], "iops")}"
  availability_zone = "${element(aws_instance.k8s-master.*.availability_zone, count.index % var.kube-master-count)}"
}

resource "aws_route53_record" "k8s-master" {
  count   = "${var.kube-master-count}"
  zone_id = "${var.kube-domain}"
  name    = "master-${count.index + 1}"
  type    = "A"
  ttl     = "600"

  records = [
    "${element(aws_instance.k8s-master.*.private_ip, count.index)}",
  ]
}
