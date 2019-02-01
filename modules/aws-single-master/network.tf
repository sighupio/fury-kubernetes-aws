resource "aws_vpc" "kube-vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags {
    Name = "kube-${var.cluster_name}-${var.environment}"
  }
}

// ----------------------------------------- PUBLIC SUBNET ---------------------------------------------
resource "aws_subnet" "public-subnet" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id     = "${aws_vpc.kube-vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index)}"
  map_public_ip_on_launch = true
  tags {
    Name = "public-${var.cluster_name}-${var.environment}-${count.index}"
  }
}

resource "aws_internet_gateway" "kube-gw" {
  vpc_id = "${aws_vpc.kube-vpc.id}"
}

resource "aws_eip" "kube-egress-ip" {
  count = "${aws_subnet.public-subnet.count}"
  vpc      = true
  depends_on = ["aws_internet_gateway.kube-gw"]
}

resource "aws_nat_gateway" "gw" {
  count = "${aws_subnet.public-subnet.count}"
  allocation_id = "${element(aws_eip.kube-egress-ip.*.id, count.index)}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id,count.index)}"
  depends_on = ["aws_internet_gateway.kube-gw"]
}

resource "aws_route_table" "internet-route" {
  vpc_id = "${aws_vpc.kube-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.kube-gw.id}"
  }
}

resource "aws_route_table_association" "public_subnet_eu_west_1a_association" {
    count = "${aws_subnet.public-subnet.count}"
    subnet_id = "${element(aws_subnet.public-subnet.*.id,count.index)}"
    route_table_id = "${aws_route_table.internet-route.id}"
}

// --------- PRIVATE SUBNETS ---------------------
data "aws_availability_zones" "available" {}

resource "aws_subnet" "kube-subnet" {
  count = 3
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  vpc_id     = "${aws_vpc.kube-vpc.id}"
  cidr_block = "${cidrsubnet(var.vpc_cidr, 8, count.index+10)}"
  map_public_ip_on_launch = false
  tags {
    Name = "kube-${var.cluster_name}-${var.environment}-${count.index}"
  }
}

resource "aws_route_table" "kube-route" {
  vpc_id = "${aws_vpc.kube-vpc.id}"
  count = "${aws_subnet.kube-subnet.count}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.gw.*.id,count.index)}"
  }
}
resource "aws_route_table_association" "kube-association" {
    count = "${aws_subnet.kube-subnet.count}"
    subnet_id = "${element(aws_subnet.kube-subnet.*.id, count.index)}"
    route_table_id = "${element(aws_route_table.kube-route.*.id, count.index)}"
}
