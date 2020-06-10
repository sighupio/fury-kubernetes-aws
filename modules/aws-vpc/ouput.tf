output "vpc" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public.*.id
}

output "private_subnets" {
  value = aws_subnet.private.*.id
}

output "domain_zone" {
  value = aws_route53_zone.main.id
}

output "additional_zone" {
  value = aws_route53_zone.additional.*.id
}

output "bastion_private_ip" {
  value = aws_instance.bastion.*.private_ip
}

output "bastion_public_ip" {
  value = aws_eip.bastion.*.public_ip
}

output "main_internet_gateway" {
  value = aws_internet_gateway.main.id
}

output "route_table_public" {
  value = aws_route_table.public.id
}

output "route_table_private" {
  value = aws_route_table.private.*.id
}

output "vpn_security_group" {
  value = aws_security_group.bastion.id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.main.*.id
}
