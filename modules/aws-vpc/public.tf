resource "aws_subnet" "public" {
  count                   = var.az-count
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${var.name}-${var.env}-${count.index}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "main" {
  count      = var.az-count
  vpc        = true
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = "nat-${var.name}-${var.env}-${count.index+1}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = var.az-count
  allocation_id = element(aws_eip.main.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id,count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name = "nat-${var.name}-${var.env}-${count.index+1}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-${var.name}-${var.env}"
  }
}

resource "aws_route" "main" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  count          = var.az-count
  subnet_id      = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.public.id
}
