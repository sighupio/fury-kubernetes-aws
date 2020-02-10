resource "aws_iam_role" "main" {
  name               = "${var.name}-${var.env}-kubernetes-role"
  assume_role_policy = "${file("${path.module}/policies/assume-role.json")}"
}

resource "aws_iam_policy" "main" {
  name   = "${var.name}-${var.env}-kubernetes-policy"
  policy = "${file("${path.module}/policies/kubernetes.json")}"
}

resource "aws_iam_policy_attachment" "main" {
  name       = "${var.name}-${var.env}-kubernetes-instance-attachment"
  roles      = ["${aws_iam_role.main.name}"]
  policy_arn = "${aws_iam_policy.main.arn}"
}

resource "aws_iam_instance_profile" "main" {
  name = "${var.name}-${var.env}-kubernetes-instance-profile"
  role = "${aws_iam_role.main.name}"
}

resource "aws_iam_policy_attachment" "join" {
  name       = "${var.name}-${var.env}-kubernetes-worker-join"
  roles      = ["${aws_iam_role.main.name}"]
  users      = ["${aws_iam_user.furyagent_worker.name}"]
  policy_arn = "${var.join-policy-arn}"
}

resource "aws_iam_user" "furyagent_worker" {
  name = "${var.name}-${var.env}-furyagent-worker"
  path = "/"
}

resource "aws_iam_access_key" "furyagent_worker" {
  user = "${aws_iam_user.furyagent_worker.name}"
}
