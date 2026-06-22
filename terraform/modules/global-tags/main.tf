locals {
  merged_tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      Team        = "Devops"
    },
    var.extra_tags
  )
}