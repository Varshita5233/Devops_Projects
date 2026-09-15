region               = "ap-south-2"
project_name         = "java-ECR-project"
environment          = "dev"
vpc_cidr             = "10.0.0.0/16"
desired_count        = 1
public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
my_ip = "103.172.203.166/32"