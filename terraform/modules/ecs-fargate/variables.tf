variable "service_name" {
  description = "Name of the service"
  type        = string
}
variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}
variable "task_arn" {
  description = "ARN of the task definition"
  type        = string
}
variable "desired_count" {
  description = "Number of tasks"
  type        = number
}
variable "subnet_ids" {
  description = "subnet IDs for the service"
  type        = list(string)
}
variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}
variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}
variable "container_name" {
  description = "Container name in the definition"
  type        = string
}
variable "container_port" {
  description = "Container port"
  type        = number
}
variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default = {

  }
}