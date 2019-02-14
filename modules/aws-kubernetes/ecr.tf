resource "aws_ecr_repository" "main" {
  name = "${var.name}-${var.env}"
}
