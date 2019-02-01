resource "aws_security_group" "kubernetes-nodes" {
  name        = "kubernetes-nodes"
  description = "kubenode Security Group"
  vpc_id      = "${aws_vpc.kube-vpc.id}"

  tags {
    Name  = "${var.environment}-${var.cluster_name}"
    Env   = "${var.environment}"
  }

  //sg for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for apiserver kubernetes
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes nginx-ingress
  ingress {
    from_port   = 31080
    to_port     = 31080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes contour-ingress
  ingress {
    from_port   = 32080
    to_port     = 32080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes jenkins-master http
  ingress {
    from_port   = 32180
    to_port     = 32180
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes jenkins-master slavelistener
  ingress {
    from_port   = 31500
    to_port     = 31500
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes weave-net: mesh, metrics-kube, metrics-npc
  ingress {
    from_port   = 6781
    to_port     = 6783
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes node_exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes kubelet metrics cadvisor
  ingress {
    from_port   = 10255
    to_port     = 10255
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    //sg for kubernetes kubelet metrics cadvisor
  ingress {
    from_port   = 10248
    to_port     = 10248
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //allow everything in egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kubernetes-master" {
  name        = "kubernetes-master"
  description = "kubemaster Security Group"
  vpc_id      = "${aws_vpc.kube-vpc.id}"

  tags {
    Name  = "${var.environment}-${var.cluster_name}"
    Env   = "${var.environment}"
  }

  //sg for ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for apiserver kubernetes
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes node_exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for  kubernetes
  ingress {
    from_port   = 31000
    to_port     = 31000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for etcd metric scraping
  ingress {
    from_port   = 2378
    to_port     = 2378
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes
  ingress {
    from_port   = 32000
    to_port     = 32000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // sg for kubernetes weave-net: mesh, metrics-kube, metrics-npc
  ingress {
    from_port   = 6781
    to_port     = 6783
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for apiserver kubelet, controller manager metrics, scheduler metrics
  ingress {
    from_port   = 10250
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //sg for kubernetes kubelet metrics cadvisor
  ingress {
    from_port   = 10255
    to_port     = 10255
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  //allow everything in egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
