output "website_url" {
    value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
  
}

output "bucket_arn" {
  value = aws_s3_bucket.mystaticwebsitebucket.arn
}

output "bucket_name" {
  value = aws_s3_bucket.mystaticwebsitebucket.bucket
}