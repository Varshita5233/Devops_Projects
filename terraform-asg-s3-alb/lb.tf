resource "aws_lb" "mylb" {
  name                       = "Terraform-VPC-project-mylb"
  load_balancer_type         = "application"
  internal                   = false
  subnets                    = module.vpc.public_subnets
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.mylb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mytg.arn
  }

}