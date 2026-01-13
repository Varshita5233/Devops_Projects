resource "aws_instance" "Monitoring_ec2" {
  ami = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [ var.vpc_security_group_ids ]
  user_data = file("${path.module}/install.sh")
  key_name = var.key_name
  root_block_device {
    volume_size = var.volume_size
  }
  tags = {
    Name = var.instance_name
  }
}