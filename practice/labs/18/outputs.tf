output "automation_environment" {
  description = "不同 shell 设置 TF_IN_AUTOMATION 的方式。"
  value       = local.automation_environment
}

output "policy_file" {
  description = "生成的自动化日志策略文件。"
  value       = local_file.automation_log_policy.filename
}

