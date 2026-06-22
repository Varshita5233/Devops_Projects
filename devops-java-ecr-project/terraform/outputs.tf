output "alb_dns_name" {
    description = "DNS name of ALB"
    value = aws_lb.main.dns_name
  
}
output "ecr_repo_url" {
    description = "ECR repo url"
    value = module.ecr.repository_url
  
}