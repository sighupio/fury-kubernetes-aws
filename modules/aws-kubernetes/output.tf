locals {
  inventory = <<EOF
master ansible_host=?
bastion ansible_host=?
[bastion]
${join("\n", var.bastion-public-ip)}

[master]
${join("\n", aws_instance.k8s-master.*.private_ip)}

${join("\n", data.template_file.worker-nodes.*.rendered)}

[gated]
master

[gated:children]
infra-nodes
production-nodes
staging-nodes

[nodes:children]
infra-nodes
production-nodes
staging-nodes

[all:vars]
ansible_ssh_private_key_file="../secrets/terraform"
ansible_user=ubuntu

[gated:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q -i ${var.ssh_private_key} ubuntu@${var.bastion-public-ip[0]}"'
EOF
}

output "inventory" {
  value = "${local.inventory}"
}

data "template_file" "worker-nodes" {
  count    = "${data.aws_instances.main.count}"
  template = <<EOF
[${lookup(var.kube-workers[count.index], "kind")}-nodes]
${join("\n", data.aws_instances.main.*.private_ips[count.index])}
EOF
}
