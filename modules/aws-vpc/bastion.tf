resource "aws_instance" "bastion" {
  count                       = "${var.bastion-count}"
  ami                         = "${data.aws_ami.main.id}"
  instance_type               = "${var.bastion-instance-type}"
  key_name                    = "${aws_key_pair.main.id}"
  subnet_id                   = "${element(aws_subnet.public.*.id, count.index)}"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

  tags {
    Name = "bastion-${var.name}-${var.env}-${count.index+1}"
    Role = "bastion"
  }

  lifecycle {
    ignore_changes = ["ami"]
  }
}

resource "aws_eip" "bastion" {
  count      = "${var.bastion-count}"
  depends_on = ["aws_internet_gateway.main"]

  tags {
    Name = "bastion-${var.name}-${var.env}-${count.index+1}"
  }
}

resource "aws_eip_association" "bastion" {
  count         = "${var.bastion-count}"
  instance_id   = "${element(aws_instance.bastion.*.id, count.index)}"
  allocation_id = "${element(aws_eip.bastion.*.id, count.index)}"
}

resource "aws_security_group" "bastion" {
  name   = "bastion-${var.env}"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "bastion-${var.name}-${var.env}"
  }
}

resource "aws_security_group_rule" "egress" {
  count       = "${var.bastion-ssh-enable}"
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "ssh" {
  count       = "${var.bastion-ssh-enable}"
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "vpn" {
  count       = "${var.bastion-vpn-enable}"
  type        = "ingress"
  from_port   = 1194
  to_port     = 1194
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.bastion.id}"
}
