variable "environment" {
  description = "Environment name (dev, qa, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "extra_tags" {
  description = "Additional custom tags"
  type        = map(string)
  default = {
  }
}