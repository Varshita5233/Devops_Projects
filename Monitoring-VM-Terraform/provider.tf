terraform {
  backend "s3" {
    bucket = "remote-backend-tf-sample-12345"
    key = "Monitoring/ec2/terraform.tfstate"
    region = "ap-south-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}