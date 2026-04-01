output "cluster_id" {
  description = "EKS Cluster ID"
  value       = aws_eks_cluster.main.id
}

output "cluster_name" {
  description = "EKS Cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "EKS Cluster API endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID for EKS cluster"
  value       = aws_security_group.eks_cluster.id
}

output "oidc_provider_arn" {
  description = "OIDC Provider ARN for IRSA"
  value       = aws_iam_openid_connect_provider.eks.arn
}

output "cluster_iam_role_arn" {
  description = "IAM Role ARN for EKS cluster"
  value       = aws_iam_role.eks_cluster.arn
}

output "cluster_certificate_authority" {
  description = "EKS Cluster certificate authority data"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}
