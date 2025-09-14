resource "aws_security_group" "alb_sg" {
  name        = "ALB-SG"
  description = "Allow HTTP from anywhere to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.cidr_block
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.cidr_block
    protocol    = "-1"
  }
}

resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Allow SSH from my IP and HTTP from ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.cidr_block
    protocol    = "tcp"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    cidr_blocks = var.cidr_block
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.cidr_block
    protocol    = "-1"
  }
}

resource "aws_security_group" "private_sg" {
  name        = "private-SG"
  description = "Allow HTTP from only ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb_sg.id]
    protocol        = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = var.cidr_block
    protocol    = "-1"
  }
}