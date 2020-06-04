resource "aws_s3_bucket" "main" {
  bucket = var.furyagent_bucket_name
  acl    = "private"

  lifecycle_rule {
    id      = "etcd"
    enabled = true

    prefix = "etcd/"

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      days = 1
    }
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = var.furyagent_bucket_name
    Cluster     = var.cluster_name
    Environment = var.environment
  }
}
