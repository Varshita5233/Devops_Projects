resource "aws_lb_target_group" "mytg" {
  name     = "terraform-project-vpc-tg"
  vpc_id   = module.vpc.vpc_id
  port     = 80
  protocol = "HTTP"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "80"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200-399"
  }

}

# resource "aws_lb_target_group_attachment" "mytg_attachment" {
#   count            = length(module.ec2.private_instance_id)
#   target_id        = module.ec2.private_instance_id[count.index]
#   target_group_arn = aws_lb_target_group.mytg.arn
#   port             = 80
# }

