output "web_instance_id" {
  description = "LocalStack 中创建的模拟 EC2 instance id。"
  value       = aws_instance.web.id
}

output "web_owner_tag" {
  description = "配置中期望的 EC2 Owner tag，后续 AWS CLI 会模拟外部系统修改远端 tag。"
  value       = "terraform"
}

output "protected_marker_name" {
  description = "用于观察 prevent_destroy 的受保护标记。"
  value       = terraform_data.protected_release_marker.input.name
}

output "lifecycle_lab_topics" {
  description = "本实验覆盖的 lifecycle meta-argument。"
  value = [
    "create_before_destroy",
    "prevent_destroy",
    "ignore_changes",
    "replace_triggered_by",
  ]
}
