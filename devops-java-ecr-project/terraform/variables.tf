variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "environment" {
  description = "Environment name"
  type        = string
}
variable "project_name" {
  description = "Project name"
  type        = string
}
variable "vpc_cidr" {
  description = "CIDR fro vpc"
  type        = string
  default     = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  description = "public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "private subnets"
  type        = list(string)
}
variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080

}

variable "desired_count" {
  description = "No of replicas"
  type        = number
}
variable "cpu" {
  type    = number
  default = 256
}
variable "memory" {
  type    = number
  default = 512
}