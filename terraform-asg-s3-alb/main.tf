terraform {
  backend "s3" {
    bucket       = "tterraformvpcprojectbucket"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true

  }
}


module "vpc" {
  source          = "./modules/vpc"
  cidr_block      = "10.0.0.0/16"
  vpc_name        = "Terraform-project-VPC"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  az              = ["us-east-1a", "us-east-1b"]
}

module "ec2" {
  source                  = "./modules/EC2"
  ami                     = "ami-00ca32bbc84273381"
  instance_type           = "t2.micro"
  public_subnets          = module.vpc.public_subnets
  private_subnets         = module.vpc.private_subnets
  public_security_groups  = [aws_security_group.public_sg.id]
  private_security_groups = [aws_security_group.private_sg.id]
  key_name                = "aws_login"

}

module "s3-static-website" {
  source = "./modules/s3-static-website"
  bucket_name = "my-static-website-test-bucket-varshita-jyotsna"
}


