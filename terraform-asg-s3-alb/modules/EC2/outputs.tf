output "public_instance_id" {
  value = aws_instance.public.id
}

# output "private_instance_id" {
#   value = aws_instance.private[*].id
# }

output "image_id" {
  value = data.aws_ssm_parameter.al2023.value
}

output "instance_type" {
  value = aws_instance.public.instance_type
}

output "key_name" {
  value = aws_instance.public.key_name
}
