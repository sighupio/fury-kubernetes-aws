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

resource "aws_rds_cluster" "main" {
  cluster_identifier      = "${var.name}-${var.env}-${var.suffix}"
  vpc_security_group_ids  = ["${aws_security_group.main.id}"]
  db_subnet_group_name    = "${aws_db_subnet_group.main.name}"
  engine                  = "${var.rds-engine}"                #"aurora"
  engine_version          = "${var.rds-engine-version}"        #"5.6.10a"
  engine_mode             = "${var.rds-engine-mode}"           #"serverless"
  master_username         = "${var.rds-user}"
  master_password         = "${var.rds-password}"
  backup_retention_period = "${var.rds-backup-retention}"
  skip_final_snapshot     = true
  apply_immediately       = true
  deletion_protection     = true

  scaling_configuration {
    auto_pause               = "${var.rds-aurora-autopause}"
    max_capacity             = "${var.rds-aurora-max-capacity}"
    min_capacity             = "${var.rds-aurora-min-capacity}"
    seconds_until_auto_pause = "${var.rds-aurora-seconds-until-auto-pause}"
  }

}

data "aws_route53_zone" "selected" {
  name         = "${var.domain_name}."
  private_zone = true
}

resource "aws_route53_record" "main" {
  count   = "${length(var.friendly_name) == 0 ? 0 : 1}"
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "${var.friendly_name}.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_rds_cluster.main.endpoint}"]
}
