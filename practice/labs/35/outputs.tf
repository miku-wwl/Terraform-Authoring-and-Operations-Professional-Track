output "selected_ami_id" {
  description = "EC2 使用的动态 AMI ID"
  value       = data.aws_ami.latest.id
}

output "instance_id" {
  description = "LocalStack 中创建的 EC2 实例 ID"
  value       = aws_instance.app.id
}
