// KUBERNETES NODES

resource "aws_iam_role" "kubernetes" {
  name = "${var.cluster_name}-${var.environment}-kubernetes-role"
  assume_role_policy = "${file("${path.module}/policies/assume-role.json")}"
}

resource "aws_iam_policy" "kubernetes" {
  name        = "${var.cluster_name}-${var.environment}-kubernetes"
  policy = "${file("${path.module}/policies/kubernetes.json")}"
}

resource "aws_iam_policy_attachment" "kubernetes" {
  name       = "kubernetes_instance_attachment"
  roles      = ["${aws_iam_role.kubernetes.name}"]
  policy_arn = "${aws_iam_policy.kubernetes.arn}"
}

resource "aws_iam_instance_profile" "kubernetes" {
  name = "${var.cluster_name}-${var.environment}-kubernetes-instance-profile"
  role = "${aws_iam_role.kubernetes.name}"
}

