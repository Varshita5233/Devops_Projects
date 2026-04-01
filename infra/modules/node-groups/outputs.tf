output "node_group_id" {
  description = "Node Group ID"
  value       = aws_eks_node_group.main.id

}
output "node_group_arn" {
  description = "Node Group ARN"
  value       = aws_eks_node_group.main.arn
}
output "node_group_role_arn" {
  description = "IAM Role ARN for node group"
  value       = aws_iam_role.node_group.arn
}
output "node_group_status" {
  description = "Status of node group"
  value       = aws_eks_node_group.main.status
}