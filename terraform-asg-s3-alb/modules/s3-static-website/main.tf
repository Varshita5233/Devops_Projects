
resource "aws_s3_bucket" "mystaticwebsitebucket" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name        = var.bucket_name
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.mystaticwebsitebucket.id

  index_document {
    suffix = "index.html"
  }
}

# Allow public access
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mystaticwebsitebucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# # Bucket policy for public read
# resource "aws_s3_bucket_policy" "bucket_policy" {
#   bucket = aws_s3_bucket.mystaticwebsitebucket.id
#  policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid       = "PublicReadGetObject",
#         Effect    = "Allow",
#         Principal = "*",
#         Action    = ["s3:GetObject"],
#         Resource  = "${aws_s3_bucket.mystaticwebsitebucket.arn}/*"
#       }
#     ]
#   })

#   depends_on = [
#     aws_s3_bucket_public_access_block.public_access
#   ]
# }

# Upload website files (index.html, style.css)
resource "aws_s3_object" "objects" {
    for_each = fileset("${path.module}/website","*")
  bucket = aws_s3_bucket.mystaticwebsitebucket.id
  key = each.value
  source = "${path.module}/website/${each.value}"
  content_type = each.value=="index.html"?"text/html":"text/css"
}

