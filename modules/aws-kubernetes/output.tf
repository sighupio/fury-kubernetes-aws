locals {
  inventory = <<EOF
[bastion]
${join("\n", var.kube-bastions)}

[master]
${join("\n", aws_instance.k8s-master.*.private_ip)}

${join("\n", data.template_file.k8s-worker-node.*.rendered)}

[gated:children]
master
${join("\n", data.template_file.k8s-worker-kind.*.rendered)}

[nodes:children]
${join("\n", data.template_file.k8s-worker-kind.*.rendered)}

[all:vars]
ansible_user=ubuntu

[gated:vars]
ansible_ssh_common_args='-o ProxyCommand="ssh -o StrictHostKeyChecking=no -W %h:%p -q ubuntu@${var.kube-bastions[0]}"'
EOF
}

output "inventory" {
  value = "${local.inventory}"
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
