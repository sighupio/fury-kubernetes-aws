resource "aws_iam_user" "main" {
  name = "${var.cluster_name}-${var.environment}-furyagent-backup"
  path = "/"
}

resource "aws_iam_policy_attachment" "main" {
  name       = "${var.cluster_name}-${var.environment}-furyagent-backup"
  users      = [aws_iam_user.main.name]
  policy_arn = aws_iam_policy.main.arn
}

resource "aws_iam_access_key" "main" {
  user = aws_iam_user.main.name
}

resource "aws_iam_policy" "main" {
  name = "${var.cluster_name}-${var.environment}-furyagent-backup"

  policy = <<EOF
{
     "Version": "2012-10-17",
     "Statement": [
         {
             "Effect": "Allow",
             "Action": [
                 "s3:*"
             ],
            "Resource": "${aws_s3_bucket.main.arn}/*"
         },
         {
             "Effect": "Allow",
             "Action": [
                 "s3:ListBucket",
                 "s3:GetBucketLocation"
             ],
            "Resource": "${aws_s3_bucket.main.arn}"
         }
     ]
}
EOF
}

resource "aws_iam_policy" "join" {
  name = "${var.cluster_name}-${var.environment}-furyagent-join"

  policy = <<EOF
{
     "Version": "2012-10-17",
     "Statement": [
         {
             "Effect": "Allow",
             "Action": [
                 "s3:*"
             ],
            "Resource": "${aws_s3_bucket.main.arn}/join/*"
         },
         {
             "Effect": "Allow",
             "Action": [
                 "s3:ListBucket",
                 "s3:GetBucketLocation"
             ],
            "Resource": "${aws_s3_bucket.main.arn}"
         }
     ]
}
EOF
}
