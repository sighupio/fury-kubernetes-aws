variable cluster_name {}
variable environment {}
variable aws_region {
  default = "eu-west-1"
}
variable vpc_cidr {}
variable kube_master_count {}
variable kube_master_type {}
variable kube_infra_node_count {}
variable kube_infra_node_type {}
variable kube_app_node_count {}
variable kube_app_node_type {}
variable bastion {}
variable root_device_size {}
variable docker_device_name {}
variable docker_device_size {}
variable ssh_public_key {}
variable ssh_private_key {}
variable default_ubuntu_ami {}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.default_ubuntu_ami}"]
  }
}

resource "aws_key_pair" "kube-key" {
  key_name   = "${var.cluster_name}-kube-key"
  public_key = "${file("${var.ssh_public_key}")}"
}

provider aws {
  region = "eu-west-1"
}
