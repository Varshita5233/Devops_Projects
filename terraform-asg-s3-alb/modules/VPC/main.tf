resource "aws_vpc" "terraform_project_vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.terraform_project_vpc.id
  count = length(var.public_subnets)
  cidr_block = var.public_subnets[count.index]
  availability_zone = element(var.az,count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.terraform_project_vpc.id
    count = length(var.private_subnets)
  cidr_block = var.private_subnets[count.index]
  availability_zone = element(var.az,count.index)
  tags = {
    Name = "${var.vpc_name}-private-${count.index+1}"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.terraform_project_vpc.id
  tags = {
    Name="${var.vpc_name}-igw"
  }
}