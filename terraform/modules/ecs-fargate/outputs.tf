output "service_id" {
  description = "The ID of ECS service"
  value       = aws_ecs_service.ecs_service_app.id
}