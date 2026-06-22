terraform {
  backend "s3" {
    region  = "ap-south-2"
    bucket  = "my-tfstate-bucket-ap-south-2"
    key     = "dev/terraform.tfstate"
    encrypt = true

  }
}