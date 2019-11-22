resource "aws_ecr_repository" "main" {
  count = "${length(var.ecr-repositories)}"
  name  = "${element(var.ecr-repositories, count.index)}"
}

resource "aws_ecr_lifecycle_policy" "main" {
  count      = "${length(var.ecr-repositories)}"
  repository = "${element(aws_ecr_repository.main.*.name, count.index)}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 60 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 60
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep last 100 images",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": ["v"],
                "countType": "imageCountMoreThan",
                "countNumber": 100
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

resource "aws_iam_user" "pusher" {
  name = "${var.name}-${var.env}-ecr-pusher"
  path = "/"
}

resource "aws_iam_policy_attachment" "pusher" {
  name       = "${var.name}-${var.env}-ecr-pusher"
  users      = ["${aws_iam_user.pusher.name}"]
  policy_arn = "${aws_iam_policy.pusher.arn}"
}

resource "aws_iam_access_key" "pusher" {
  user = "${aws_iam_user.pusher.name}"
}

resource "aws_iam_policy" "pusher" {
  name = "${var.name}-${var.env}-ecr-pusher"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetRepositoryPolicy",
                "ecr:DescribeRepositories",
                "ecr:ListImages",
                "ecr:DescribeImages",
                "ecr:BatchGetImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

locals {
  ecr-pusher = <<EOF
export AWS_ACCESS_KEY_ID=${aws_iam_access_key.pusher.id}
export AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.pusher.secret}
export AWS_DEFAULT_REGION=${var.region}
# `aws ecr get-login --no-include-email --region eu-west-1`
#${join("\n#", aws_ecr_repository.main.*.repository_url)}
EOF
}

output "ecr-pusher" {
  value = "${local.ecr-pusher}"
}
