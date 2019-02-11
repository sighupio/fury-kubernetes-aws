

module "kube-sighup" {
    source = "../vendor/modules/aws-single-master"
    cluster_name = "flyer-tech-cluster"
    environment = "prod"
    aws_region = "${var.aws_region}"
    
    kube_master_count = 1
    kube_master_type = "t2.medium"
    kube_infra_node_count = 2
    kube_infra_node_type = "m5.large"
    kube_app_node_count = 3
    kube_app_node_type = "c5.large"
    bastion = "t2.nano"
    root_device_size = 60
    docker_device_name = "/dev/sdf"
    docker_device_size = 5
    ssh_public_key = "../secrets/terraform.pub"
    ssh_private_key = "../secrets/terraform"
    default_ubuntu_ami = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-20180912"
}