terraform {
  required_version = ">=1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~>2.0"
    }
  }
}

# terraform {
#   backend "s3" {
#     bucket = "value"
#     key = "value"
#     region = "ap-south-2"
#     encrypt = true
#     use_lockfile = true
#   }
# }

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "EKS-Terraform"
      ManagedBy   = "Terraform"
      Owner       = "Jyotsna"
      Environment = var.environment
    }
  }
}