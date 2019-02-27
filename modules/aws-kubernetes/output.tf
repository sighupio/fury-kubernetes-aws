locals {
  inventory = <<EOF
[bastion]
${join("\n", formatlist("%s ansible_host=%s", data.template_file.bastion.*.rendered, var.kube-bastions))}

[master]
${join("\n", formatlist("%s ansible_host=%s", data.template_file.k8s-master.*.rendered, aws_instance.k8s-master.*.private_ip))}

${join("\n", data.template_file.k8s-worker-node.*.rendered)}

[gated:children]
master
${join("\n", data.template_file.k8s-worker-kind.*.rendered)}

[nodes:children]
${join("\n", data.template_file.k8s-worker-kind.*.rendered)}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file='${var.ssh-private-key}'
ansible_python_interpreter=python3

[gated:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q -i ${var.ssh-private-key} ubuntu@${var.kube-bastions[0]}"'
public_lb_address=${aws_lb.external.dns_name}

[master:vars]
etcd_initial_cluster='${join(",", formatlist("%s=https://%s:2380", data.template_file.k8s-master.*.rendered, aws_route53_record.k8s-master.*.fqdn))}'
control_plane_endpoint=${aws_route53_record.control-plane.fqdn}
dns_zone=${join(".",compact(split(".",data.aws_route53_zone.main.name)))}

EOF
}

output "inventory" {
  value = "${local.inventory}"
}

data "template_file" "bastion" {
  count = "${length(var.kube-bastions)}"

  template="bastion-$${index}"

  vars {
    index = "${count.index}"
  }
}

data "template_file" "k8s-master" {
  count = "${var.kube-master-count}"

  template="master-$${index}"

  vars {
    index = "${count.index}"
  }
}

data "template_file" "k8s-worker-kind" {
  count    = "${length(var.kube-workers)}"
  template = "$${kind}"

  vars {
    kind = "${lookup(var.kube-workers[count.index], "kind")}"
  }
}

data "template_file" "k8s-worker-node" {
  count = "${data.aws_instances.main.count}"

  template = <<EOF
[$${kind}]
$${nodes}
EOF

  vars {
    kind  = "${lookup(var.kube-workers[count.index], "kind")}"
    nodes = "${join("\n", data.aws_instances.main.*.private_ips[count.index])}"
  }
}
