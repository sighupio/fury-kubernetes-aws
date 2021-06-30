data "aws_elb_service_account" "main" {
}

data "aws_iam_policy_document" "main" {
  statement {
    sid = ""

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }

    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${var.name}-${var.env}-external-lb-logs/*",
    ]
  }
}

resource "aws_s3_bucket" "main" {
  count  = var.kube-lb-external-enable-access-log ? 1 : 0
  bucket = "${var.name}-${var.env}-external-lb-logs"
  acl    = "log-delivery-write"
  policy = data.aws_iam_policy_document.main.json

  lifecycle_rule {
    id      = "${var.name}-${var.env}-external-lb-logs"
    enabled = true

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      days = 30
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "${var.name}-${var.env}-external-lb-logs"
    Environment = var.env
  }
}

