resource "aws_eip" "myeip" {
  domain = "vpc"

  tags = {
    Name = "Terraform-VPC-project-eip"
  }
}

resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.myeip.id
  subnet_id = aws_subnet.public[0].id
}