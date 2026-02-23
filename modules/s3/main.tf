module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = ">= 3.0.0"

  bucket = var.bucket_name

  # Enable versioning
  versioning = {
    enabled = true
  }

  # Server-side encryption
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  # Public access block (keep private by default)
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # Attach a bucket policy for common permissions (e.g., allow all operations for the account root)
  # Note: For production, restrict this further
  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })

  tags = {
    Name        = var.bucket_name
    Environment = "test"
  }
}

data "aws_caller_identity" "current" {}