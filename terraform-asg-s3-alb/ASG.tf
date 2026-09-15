resource "aws_launch_template" "myasg_launch_template" {
  name                   = "Terraform-VPC-launch-Template"
  description            = "My launch template for ASG"
  image_id               = module.ec2.image_id
  instance_type          = module.ec2.instance_type
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = module.ec2.key_name

  user_data = filebase64("${path.module}/userdata.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-profile.name
  }

  ebs_optimized          = true
  update_default_version = true
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      delete_on_termination = true

    }
  }
  monitoring {
    enabled = true
  }
}

resource "aws_autoscaling_group" "my_asg" {
  name                      = "Terraform-VPC-myASG"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_type         = "ELB"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.myasg_launch_template.id
    version = aws_launch_template.myasg_launch_template.latest_version
  }
  target_group_arns = [aws_lb_target_group.mytg.arn]


}

# Scale OUT policy (add 1 instance)
resource "aws_autoscaling_policy" "scale_out" {
  name = "scale-out"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = 1
  cooldown = 300
}

# Scale IN policy (remove 1 instance)
resource "aws_autoscaling_policy" "scale_in" {
  name = "scale-in"
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300

}
