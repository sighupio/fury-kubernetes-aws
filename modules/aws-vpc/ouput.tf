output "vpc" {
  value = "${aws_vpc.main.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "public_subnets" {
  value = "${flatten(aws_subnet.public.*.id)}"
}

output "private_subnets" {
  value = "${flatten(aws_subnet.private.*.id)}"
}

output "domain_zone" {
  value = "${aws_route53_zone.main.id}"
}

output "additional_zone" {
  value = "${aws_route53_zone.additional.*.id}"
}

output "bastion_private_ip" {
  value = "${flatten(aws_instance.bastion.*.private_ip)}"
}

output "bastion_public_ip" {
  value = "${flatten(aws_eip.bastion.*.public_ip)}"
}

output "main_internet_gateway"{
  value = "${aws_internet_gateway.main.id}"
}

output "bastion_count" {
  value = "${var.bastion-count}"
}