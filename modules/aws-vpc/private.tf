locals {
  private_subnet_tags = map(
    "kubernetes.io/cluster/${var.name}-${var.env}", "shared",
    "kubernetes.io/role/internal-elb", "1"
  )
}

resource "aws_subnet" "private" {
  count                   = var.az-count
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, count.index + 10)
  map_public_ip_on_launch = false

  tags = merge(
    local.private_subnet_tags,
    map(
      "Name", "private-${var.name}-${var.env}-${count.index}"
    )
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  count  = var.az-count

  tags = {
    Name = "private-${var.name}-${var.env}-${count.index + 1}"
  }
}

resource "aws_route" "private" {
  count                  = var.az-count
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  count          = var.az-count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

