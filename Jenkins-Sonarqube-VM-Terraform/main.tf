module "jenkins_ec2" {
  source = "./modules/jenkins"
  ami_id = var.ami_id
  volume_size = var.volume_size
  instance_name = var.instance_name
  instance_type = var.instance_type
  vpc_security_group_ids = module.sg.security_group_ids
  key_name = var.key_name
}

module "sg" {
  source = "./modules/security_groups"
  sg_name = var.sg_name
  ingress_rules = var.ingress_rules
  protocol = var.protocol
  cidr_blocks = var.cidr_blocks
}