resource "aws_iam_role" "main" {
  name               = "${var.name}-${var.env}-kubernetes-role"
  assume_role_policy = "${file("${path.module}/policies/assume-role.json")}"
}

resource "aws_iam_policy" "main" {
  name   = "${var.name}-${var.env}-kubernetes-policy"
  policy = "${file("${path.module}/policies/kubernetes.json")}"
}

resource "aws_iam_policy_attachment" "main" {
  name       = "kubernetes_instance_attachment"
  roles      = ["${aws_iam_role.main.name}"]
  policy_arn = "${aws_iam_policy.main.arn}"
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.name}-${var.env}-kubernetes-instance-profile"
  role = "${aws_iam_role.main.name}"
}
