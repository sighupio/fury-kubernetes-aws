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

# resource "aws_volume_attachment" "kube-master-ebs-attach" {
#   count       = "${length(var.kube-master-volumes) * var.kube-master-count}"
#   device_name = "${lookup(var.kube-master-volumes[(count.index / var.kube-master-count) % length(var.kube-master-volumes)], "device_name")}"
#   volume_id   = "${element(aws_ebs_volume.kube-master-ebs.*.id, (count.index / var.kube-master-count) + ((count.index * var.kube-master-count) % (length(var.kube-master-volumes) * var.kube-master-count)))}"

#   # volume_id   = "${aws_ebs_volume.kube-master-ebs.*.id["${count.index % length(var.kube-master-volumes)}"]}"
#   instance_id = "${element(aws_instance.k8s-master.*.id, count.index % var.kube-master-count)}"
# }

# #resource "aws_volume_attachment" "kube-master-ebs-attach" {
# #  count = "${length(var.kube-master-volumes) != 0 ? length(var.kube-master-volumes) * var.kube-master-count : 0}"
# #  device_name = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "device_name")}"
# #  volume_id   = "${aws_ebs_volume.kube-master-ebs.*.id["${count.index % length(var.kube-master-volumes)}"]}"
# #  instance_id = "${aws_instance.k8s-master.*.id["${count.index % var.kube-master-count}"]}"
# #}
# #
# #resource "aws_ebs_volume" "kube-master-ebs" {
# #  count = "${length(var.kube-master-volumes) != 0 ? length(var.kube-master-volumes) * var.kube-master-count : 0}"
# #  size = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "size")}"
# #  type = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "type")}"
# #  iops = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "iops")}"
# #  availability_zone = "us-west-1a"
# #}

# resource "aws_ebs_volume" "kube-master-ebs" {
#   count             = "${length(var.kube-master-volumes) * var.kube-master-count}"
#   size              = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "size")}"
#   type              = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "type")}"
#   iops              = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "iops")}"
#   availability_zone = "${element(aws_instance.k8s-master.*.availability_zone, (count.index / var.kube-master-count) % var.kube-master-count)}"
#   # availability_zone = "${element(aws_instance.k8s-master.*.availability_zone, count.index % var.kube-master-count)}"
# }

# data "template_file" "test" {
#   count = "${length(var.kube-master-volumes) * var.kube-master-count}"

#   template = <<EOF
# count = $${count}
# instance_id = $${instance_id}
# volume_id = $${volume_id}
# instance_az = $${instance_az}
# volume_az = $${volume_az}
# device_name = $${device_name}
# volume_type = $${volume_type}
# EOF

#   vars {
#     count = "${count.index}"

#     # device_name = "${lookup(var.kube-master-volumes[count.index % length(var.kube-master-volumes)], "device_name")}"
#     device_name = "${lookup(var.kube-master-volumes[(count.index / var.kube-master-count) % length(var.kube-master-volumes)], "device_name")}"
#     instance_id = "${element(aws_instance.k8s-master.*.id, count.index % var.kube-master-count)}"
#     volume_id   = "${element(aws_ebs_volume.kube-master-ebs.*.id, (count.index / var.kube-master-count) + ((count.index * var.kube-master-count) % (length(var.kube-master-volumes) * var.kube-master-count)))}"
#     volume_type = "${element(aws_ebs_volume.kube-master-ebs.*.type, (count.index / var.kube-master-count) + ((count.index * var.kube-master-count) % (length(var.kube-master-volumes) * var.kube-master-count)))}"
#     instance_az = "${element(aws_instance.k8s-master.*.availability_zone, count.index % var.kube-master-count)}"
#     volume_az   = "${element(aws_ebs_volume.kube-master-ebs.*.availability_zone, (count.index / var.kube-master-count) + ((count.index * var.kube-master-count) % (length(var.kube-master-volumes) * var.kube-master-count)))}"
#   }
# }

# output "master" {
#   value = "${join("\n", aws_instance.k8s-master.*.id)}"
# }

# output "vols" {
#   value = "${join("\n", aws_ebs_volume.kube-master-ebs.*.id)}"
# }

# output "vols-type" {
#   value = "${join("\n", aws_ebs_volume.kube-master-ebs.*.type)}"
# }

# output "vols_att" {
#   value = "${join("\n", aws_volume_attachment.kube-master-ebs-attach.*.id)}"
# }

# output "volumes" {
#   value = "${data.template_file.test.*.rendered}"
# }

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
