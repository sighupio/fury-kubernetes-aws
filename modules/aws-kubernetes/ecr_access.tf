resource "aws_ecr_repository_policy" "main" {
  count      = var.ecr-additional-pull-account-id != "" ? length(var.ecr-repositories) : 0
  repository = element(aws_ecr_repository.main.*.name, count.index)

  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "Allow${var.ecr-additional-pull-account-id}",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.ecr-additional-pull-account-id}:root"
      },
      "Action": "ecr:*"
    }
  ]
}
EOF

}

