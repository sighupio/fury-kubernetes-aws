resource "aws_instance" "kube-bastion" {
  ami      = "${data.aws_ami.ubuntu.id}"
  instance_type = "${var.bastion}"
  key_name      = "${aws_key_pair.kube-key.id}"
  subnet_id     = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
    delete_on_termination = "true"
  }

  tags {
    Name = "kube-bastion-${var.cluster_name}-${var.environment}"
    Role = "bastion"
  }
}

resource "aws_eip" "kube-bastion" {
  depends_on = ["aws_internet_gateway.kube-gw"]
}

resource "aws_eip_association" "kube-bastion" {
  instance_id = "${aws_instance.kube-bastion.id}"
  allocation_id = "${aws_eip.kube-bastion.id}"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-${var.environment}"
  description = "Allow ssh inbound traffic"
  vpc_id      = "${aws_vpc.kube-vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "TCP"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "UDP"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "bastion_ip" {
  value = "${aws_instance.kube-bastion.private_ip}"
}

output "bastion_eip" {
   value = "${aws_eip.kube-bastion.public_ip}"
}