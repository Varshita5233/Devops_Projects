variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string

}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

variable "environment" {
  description = "Environment name"
  type        = string

}
variable "project_name" {
  description = "Project name for resource naming"
  type        = string

}

variable "availabilty_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}
