resource "aws_security_group" "kubernetes-nodes" {
  name        = "k8s-nodes-${var.name}-${var.env}"
  description = "Kubernetes nodes Security Group"
  vpc_id      = "${data.aws_subnet.private.0.vpc_id}"

  tags {
    Name = "k8s-nodes-${var.name}-${var.env}"
    Env  = "${var.env}"
  }
}

resource "aws_security_group_rule" "k8s-node-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-node-apiserver" {
  type              = "ingress"
  from_port         = 10250
  to_port           = 10250
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-node-nginx-ingress" {
  type              = "ingress"
  from_port         =  31080
  to_port           =  31080
  protocol          =  "tcp"
  cidr_blocks       =  ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-node-weave-net" {
  type              = "ingress"
  from_port         = 6781
  to_port           = 6783
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-node-node-exporter" {
  type              = "ingress"
  from_port         = 9100
  to_port           = 9100
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-node-kubelet" {
  type              = "ingress"
  from_port         = 10255
  to_port           = 10255
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-node-cadvisor" {
  type              = "ingress"
  from_port         = 10248
  to_port           = 10248
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-node-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group_rule" "k8s-nodes-sg-rules" {
  count             = "${length(var.kube-workers-security-group)}"
  type              = "${lookup(var.kube-workers-security-group[count.index], "type")}"
  from_port         = "${lookup(var.kube-workers-security-group[count.index], "from_port")}"
  to_port           = "${lookup(var.kube-workers-security-group[count.index], "to_port")}"
  protocol          = "${lookup(var.kube-workers-security-group[count.index], "protocol")}"
  cidr_blocks       = ["${lookup(var.kube-workers-security-group[count.index], "cidr_blocks")}"]
  security_group_id = "${aws_security_group.kubernetes-nodes.id}"
}

resource "aws_security_group" "kubernetes-master" {
  name        = "k8s-master-${var.name}-${var.env}"
  description = "Kubernetes master Security Group"
  vpc_id      = "${data.aws_subnet.private.0.vpc_id}"

  tags {
    Name = "k8s-master-${var.name}-${var.env}"
    Env  = "${var.env}"
  }

#  //sg for  kubernetes
#  ingress {
#    from_port   = 31000
#    to_port     = 31000
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  //sg for kubernetes
#  ingress {
#    from_port   = 32000
#    to_port     = 32000
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
}

resource "aws_security_group_rule" "k8s-master-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}

resource "aws_security_group_rule" "k8s-master-apiserver" {
  type              = "ingress"
  from_port         =  6443
  to_port           =  6443
  protocol          =  "tcp"
  cidr_blocks       =  ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}

resource "aws_security_group_rule" "k8s-master-etcd-metrics" {
  type              = "ingress"
  from_port         = 2378
  to_port           = 2378
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}

resource "aws_security_group_rule" "k8s-master-weave-net" {
  type              = "ingress"
  from_port         = 6781
  to_port           = 6783
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}

//sg for apiserver kubelet, controller manager metrics, scheduler metrics
resource "aws_security_group_rule" "k8s-master-metrics" {
  type              = "ingress"
  from_port         = 10250
  to_port           = 10252
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}

resource "aws_security_group_rule" "k8s-master-kubelet" {
  type              = "ingress"
  from_port         = 10255
  to_port           = 10255
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}

resource "aws_security_group_rule" "k8s-master-all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}

resource "aws_security_group_rule" "k8s-master-sg-rules" {
  count             = "${length(var.kube-master-security-group)}"
  type              = "${lookup(var.kube-master-security-group[count.index], "type")}"
  from_port         = "${lookup(var.kube-master-security-group[count.index], "from_port")}"
  to_port           = "${lookup(var.kube-master-security-group[count.index], "to_port")}"
  protocol          = "${lookup(var.kube-master-security-group[count.index], "protocol")}"
  cidr_blocks       = ["${lookup(var.kube-master-security-group[count.index], "cidr_blocks")}"]
  security_group_id = "${aws_security_group.kubernetes-master.id}"
}
