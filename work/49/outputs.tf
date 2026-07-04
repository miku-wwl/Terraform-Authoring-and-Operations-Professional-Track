output "web_instance_id" {
  description = "LocalStack 中创建的模拟 EC2 instance id。"
  value       = aws_instance.web.id
}

output "externally_managed_tag_key" {
  description = "本实验中由外部系统修改、Terraform 应忽略漂移的 tag key。"
  value       = "Owner"
}

output "configured_owner_tag" {
  description = "Terraform 配置中的 Owner tag 期望值。"
  value       = "terraform"
}
