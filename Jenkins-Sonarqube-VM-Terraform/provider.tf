terraform {
  backend "s3" {
    bucket = "varshita-s3-demo-buckett"
    key = "terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-south-1"
}