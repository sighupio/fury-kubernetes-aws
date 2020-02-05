resource "aws_efs_file_system" "efs" {
  creation_token = "${var.name}-${var.env}-efs"
  tags {
    Name = "${var.name}-${var.env}-efs"
  }
}


resource "aws_efs_mount_target" "az_efs"{
  count = "${length(var.subnets)}"
  file_system_id = "${aws_efs_file_system.efs.id}"
  subnet_id      = "${element(var.subnets,count.index)}"
  security_groups = ["${aws_security_group.efs.id}"]
}

resource "aws_security_group" "efs" {
  name = "${var.name}-${var.env}-efs"

  description = "${var.name}-${var.env}-efs"
  vpc_id = "${var.vpc_id}"

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group Rules

resource "aws_security_group_rule" "allow_intracluster-efs" {
  type            = "ingress"
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = ["${var.allowed_cidr}"]
  description     = "efs access"
  security_group_id = "${aws_security_group.efs.id}"
}