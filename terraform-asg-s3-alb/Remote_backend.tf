# resource "aws_s3_bucket" "mybucket" {
#   bucket = "tterraformvpcprojectbucket"
# }

# resource "aws_s3_bucket_versioning" "mybucket_versioning" {
#   bucket = aws_s3_bucket.mybucket.id
#   versioning_configuration {
#     status = "Enabled"
#   }
# }


# resource "aws_dynamodb_table" "my_dynamo" {
#   name = "terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key = "LockID"
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }