data "aws_ssm_parameter" "al2023" {
  name   = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-x86_64"
  region = "us-east-1"
}



resource "aws_instance" "public" {
  ami = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type
  subnet_id = var.public_subnets[0]
  vpc_security_group_ids = var.public_security_groups
  key_name = var.key_name

  tags = {
    Name = "Terraform-VPC-project-EC2-public"
  }

user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
EOF


}

# resource "aws_instance" "private" {
#   count = length(var.private_subnets)
#   ami = data.aws_ssm_parameter.al2023.value
#   instance_type = var.instance_type
#   subnet_id = var.private_subnets[count.index]
#   vpc_security_group_ids = var.private_security_groups
#   key_name = "aws_login"
#    tags = {
#     Name = "Terraform-VPC-project-EC2-private-${count.index + 1}"
#   }

# user_data = <<-EOF
# #!/bin/bash
# dnf update -y
# dnf install -y httpd
# systemctl start httpd
# systemctl enable httpd
# echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
# EOF

# }

