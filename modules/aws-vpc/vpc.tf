locals {
  vpc_tags = map(
    "kubernetes.io/cluster/${var.name}-${var.env}", "shared",
  )
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.vpc_tags,
    map(
      "Name", "vpc-${var.name}-${var.env}",
    )
  )
}

