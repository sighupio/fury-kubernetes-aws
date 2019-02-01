locals {
    inventory = <<EOF
master ansible_host=${aws_instance.k8s-master.private_ip}
bastion ansible_host=${aws_eip.kube-bastion.public_ip}

[infra-nodes]
${join("\n",data.aws_instances.infra-nodes.private_ips)}

[app-nodes]
${join("\n",data.aws_instances.app-nodes.private_ips)}

[master]
master

[gated]
master

[gated:children]
infra-nodes
app-nodes

[nodes:children]
infra-nodes
app-nodes

[all:vars]
ansible_ssh_private_key_file="../secrets/terraform"
ansible_user=ubuntu

[gated:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q -i ${var.ssh_private_key} ubuntu@${aws_eip.kube-bastion.public_ip}"'
kubernetes_cluster_name=${var.cluster_name}
kubernetes_external_address=${aws_lb.k8s-master.dns_name}
EOF
}

output "inventory" {
    value = "${local.inventory}"
}