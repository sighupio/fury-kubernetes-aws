resource "aws_instance" "k8s-master" {
  count                  = "${var.kube-master-count}"
  ami                    = "${data.aws_ami.ubuntu.id}"
  instance_type          = "${var.kube-master-type}"
  user_data              = "${data.template_cloudinit_config.config.rendered}"
  subnet_id              = "${element(data.aws_subnet.private.*.id, count.index)}"
  iam_instance_profile   = "${aws_iam_instance_profile.main.name}"
  vpc_security_group_ids = ["${aws_security_group.kubernetes-master.id}"]

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "80"
    delete_on_termination = "true"
  }

  tags {
    Name              = "kube-master-${var.name}-${var.env}-${count.index+1}"
    Role              = "master"
    Gated             = "true"
    KubernetesCluster = "${var.name}-${var.env}"
  }
}

#resource "aws_volume_attachment" "kube-master-ebs-attach" {
#  count = "${length(var.kube-master-volumes) != 0 ? length(var.kube-master-volumes) * var.kube-master-count : 0}"
#  device_name = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "device_name")}"
#  volume_id   = "${aws_ebs_volume.kube-master-ebs.*.id["${count.index % length(var.kube-master-volumes)}"]}"
#  instance_id = "${aws_instance.k8s-master.*.id["${count.index % var.kube-master-count}"]}"
#}
#
#resource "aws_ebs_volume" "kube-master-ebs" {
#  count = "${length(var.kube-master-volumes) != 0 ? length(var.kube-master-volumes) * var.kube-master-count : 0}"
#  size = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "size")}"
#  type = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "type")}"
#  iops = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "iops")}"
#  availability_zone = "us-west-1a"
#}

resource "aws_route53_record" "k8s-master" {
  count   = "${var.kube-master-count}"
  zone_id = "${var.kube-domain}"
  name    = "master-${count.index+1}"
  type    = "A"
  ttl     = "600"

  records = [
    "${element(aws_instance.k8s-master.*.private_ip, count.index)}",
  ]
}
