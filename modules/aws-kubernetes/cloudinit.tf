data "template_file" "ssh_keys" {
  count    = "${length(var.ssh-public-keys)}"
  template = "- $${ssh-public-key}"

  vars {
    ssh-public-key = "${element("${var.ssh-public-keys}", count.index)}"
  }
}

data "template_file" "cloud-init-keys" {
  template = "${file("${path.module}/cloudinit/userdata-template.yml")}"

  vars {
    ssh-authorized-keys = "${indent(2, join("\n", "${data.template_file.ssh_keys.*.rendered}"))}"
  }
}

data "template_file" "cloud-init-workers" {
  template = "${file("${path.module}/cloudinit/worker-join.sh")}"

  vars {
    join_token_url = "${var.join-token-url}"
  }
}

data "template_cloudinit_config" "config_master" {
  gzip = false

  part {
    filename     = "ssh-authorized-keys.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud-init-keys.rendered}"
  }
}

data "template_cloudinit_config" "config_worker" {
  gzip = false

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.cloud-init-workers.rendered}"
  }

  part {
    filename     = "ssh-authorized-keys.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud-init-keys.rendered}"
  }
}
