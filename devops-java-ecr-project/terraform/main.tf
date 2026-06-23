provider "aws" {
  region = var.region
}

module "global_tags" {
  source       = "./modules/global-tags"
  environment  = var.environment
  project_name = var.project_name
  extra_tags = {
    "DeployedBy" = "Varshita"
  }
}

data "aws_availability_zones" "available" {
  state = "available"

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name            = "${var.project_name}-${var.environment}-vpc"
  cidr            = var.vpc_cidr
  azs             = data.aws_availability_zones.available.names
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_dns_hostnames    = true
  enable_dns_support      = true
  map_public_ip_on_launch = true
  enable_nat_gateway      = false
  tags                    = module.global_tags.tags
}

# ---- Security Group for ALB (Allows Internet traffic on port 80) ----
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]   # Allow traffic only from my laptop IP on port 80
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.global_tags.tags
}

# ---- Security Group for ECS Tasks (Allows traffic from ALB on port 8080) ----
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "Allow traffic from ALB to ECS tasks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = var.container_port   # 8080
    to_port         = var.container_port   # 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]   # ONLY allow traffic from the ALB SG!
    # (This is better than opening to 0.0.0.0/0)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.global_tags.tags
}

module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "2.1.0"

  repository_name = "java-spring-ecr-project"
  repository_type = "private"
  repository_image_tag_mutability = "MUTABLE"
  create_lifecycle_policy = false

  tags = module.global_tags.tags

}

resource "aws_lb" "main" {
  name                       = "${var.project_name}-${var.environment}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false
  tags                       = module.global_tags.tags



}

resource "aws_lb_target_group" "app" {
  name_prefix = "java-"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
  tags = module.global_tags.tags

}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
  tags = module.global_tags.tags

}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.project_name}-${var.environment}-iam"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = module.global_tags.tags

}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-${var.environment}-cluster"
  tags = module.global_tags.tags
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-${var.environment}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "java-app"
      image     = "${module.ecr.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])

}

module "ecs_service" {
  source             = "./modules/ecs-fargate"
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  service_name       = "${var.project_name}-${var.environment}-service"
  desired_count      = var.desired_count
  security_group_ids = [aws_security_group.app_sg.id]
  subnet_ids         = module.vpc.public_subnets
  container_name     = "java-app"
  container_port     = var.container_port
  tags               = module.global_tags.tags
  target_group_arn   = aws_lb_target_group.app.arn
  task_arn           = aws_ecs_task_definition.app.arn
}

