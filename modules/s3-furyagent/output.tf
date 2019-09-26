locals {
  furyagent_ansible_secrets = <<EOF
---

aws_access_key: "${aws_iam_access_key.main.id}"
aws_secret_key: "${aws_iam_access_key.main.secret}"
aws_region: "${var.aws_region}"
s3_bucket_name: "${var.furyagent_bucket_name}"
EOF
}

output "furyagent_ansible_secrets" {
  value = "${local.furyagent_ansible_secrets}"
}

output "bucket_username" {
  value = "${aws_iam_user.main.name}"
}

output "bucket_policy" {
  value = "${aws_iam_policy.main.arn}"
}

output "bucket_policy_join" {
  value = "${aws_iam_policy.join.arn}"
}

output "bucket_url" {
  value = "${aws_s3_bucket.main.bucket_domain_name}/join"
}
