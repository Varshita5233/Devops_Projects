resource "aws_iam_role" "test_role" {
  name = "iam-demo-role-cloudwatch"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "s3_readonly_policy" {
  name   = "S3ReadOnlyAccessForWebsite"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowListBucket",
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = module.s3-static-website.bucket_arn
      },
      {
        Sid    = "AllowGetObject",
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = "${module.s3-static-website.bucket_arn}/*"
      }
    ]
  })
}
