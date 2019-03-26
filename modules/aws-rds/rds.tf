resource "aws_rds_cluster" "main" {
  cluster_identifier              = "${var.name}-${var.env}-rds"
  engine                          = "${var.rds-engine}"
  engine_version                  = "${var.rds-engine-version}"
  availability_zones              = ["${data.aws_subnet.main.*.availability_zone}"]
  master_username                 = "${var.rds-user}"
  master_password                 = "${var.rds-password}"
  backup_retention_period         = "${var.rds-backup-retention}"
  preferred_backup_window         = "00:00-02:00"
  preferred_maintenance_window    = "fri:03:00-fri:06:00"
  port                            = "${var.rds-port}"
  vpc_security_group_ids          = ["${aws_security_group.main.id}"]
  storage_encrypted               = true
  db_subnet_group_name            = "${aws_db_subnet_group.main.name}"
  db_cluster_parameter_group_name = "${length(var.rds-parameter-group-name) > 0 ? var.rds-parameter-group-name : join("", aws_rds_cluster_parameter_group.main.*.name)}"

  tags {
    Name        = "${var.name}-${var.env}-rds"
    Environment = "${var.env}"
  }
}

resource "aws_rds_cluster_parameter_group" "main" {
  count     = "${length(var.rds-parameter-group-name) == 0 ? 1 : 0}"
  name      = "${var.name}-${var.env}-pg"
  family    = "${var.rds-parameter-group-family}"
  parameter = "${var.rds-parameter}"

  tags {
    Name        = "${var.name}-${var.env}-pg"
    Environment = "${var.env}"
  }
}

resource "aws_rds_cluster_instance" "main" {
  count                = "${var.rds-nodes-count}"
  identifier           = "${var.name}-${var.env}-rds-${count.index + 1}"
  cluster_identifier   = "${aws_rds_cluster.main.id}"
  instance_class       = "${var.rds-nodes-type}"
  publicly_accessible  = false
  db_subnet_group_name = "${aws_db_subnet_group.main.name}"
  availability_zone    = "${element(data.aws_subnet.main.*.availability_zone, count.index % length(var.subnets))}"
  engine               = "${var.rds-engine}"
  engine_version       = "${var.rds-engine-version}"
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.name}-${var.env}"
  subnet_ids = ["${var.subnets}"]
}

resource "aws_security_group" "main" {
  name_prefix = "${var.name}-${var.env}-rds"
  vpc_id      = "${data.aws_subnet.main.0.vpc_id}"

  ingress {
    from_port   = "${var.rds-port}"
    to_port     = "${var.rds-port}"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
