resource "aws_route53_zone" "main" {
  name = var.internal-zone

  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_zone" "additional" {
  count = var.additional-zone == "" ? 0 : 1
  name  = var.additional-zone

  vpc {
    vpc_id = aws_vpc.main.id
  }
}
