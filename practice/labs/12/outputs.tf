output "provider_installation_policy" {
  description = "provider installation 显式安装策略。"
  value       = local.provider_installation_policy
}

output "policy_file" {
  description = "生成的 provider installation 策略文件。"
  value       = local_file.provider_installation_policy.filename
}

