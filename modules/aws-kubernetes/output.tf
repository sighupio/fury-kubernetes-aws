locals {
  inventory = <<EOF
[bastion]
${join(
  "\n",
  formatlist(
    "%s ansible_host=%s",
    data.template_file.bastion.*.rendered,
    var.kube-bastions,
  ),
  )}

[master]
${join(
  "\n",
  formatlist(
    "%s ansible_host=%s",
    data.template_file.k8s-master.*.rendered,
    aws_instance.k8s-master.*.private_ip,
  ),
  )}

[gated:children]
master

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file='${var.ssh-private-key}'
ansible_python_interpreter=python3

[bastion:vars]
dns_server=${cidrhost(data.aws_vpc.main.cidr_block, 2)}

[gated:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q ${var.ssh-private-key != "" ? "-i" : ""} ${var.ssh-private-key} ubuntu@${var.kube-bastions[0]}"'
public_lb_address=${aws_lb.external.dns_name}

[master:vars]
etcd_initial_cluster='${join(
  ",",
  formatlist(
    "%s=https://%s:2380",
    data.template_file.k8s-master.*.rendered,
    aws_route53_record.k8s-master.*.fqdn,
  ),
)}'
control_plane_endpoint=${aws_route53_record.control-plane.fqdn}
dns_zone=${join(".", compact(split(".", data.aws_route53_zone.main.name)))}
env=${var.env}

EOF

}

output "inventory" {
  value = local.inventory
}

output "external-lb-arn" {
  value = aws_lb.external.arn
}

output "external-lb-dns-name" {
  value = aws_lb.external.dns_name
}

output "internal-lb-arn" {
  value = aws_lb.internal-http.arn
}

output "internal-lb-dns-name" {
  value = aws_lb.internal-http.dns_name
}

output "masters-security-group" {
  value = "${aws_security_group.kubernetes-master.id}"
}

output "nodes-security-group" {
  value = "${aws_security_group.kubernetes-nodes.id}"
}

data "template_file" "bastion" {
  count = length(var.kube-bastions)

  template = "bastion-$${index}"

  vars = {
    index = count.index
  }
}

data "template_file" "k8s-master" {
  count = var.kube-master-count

  template = "master-$${index+1}"

  vars = {
    index = count.index
  }
}

