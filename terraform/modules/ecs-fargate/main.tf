resource "aws_ecs_service" "ecs_service_app" {
  name             = var.service_name
  cluster          = var.cluster_name
  desired_count    = var.desired_count
  task_definition  = var.task_arn
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  network_configuration {
    security_groups  = var.security_group_ids
    subnets          = var.subnet_ids
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  tags = var.tags
}