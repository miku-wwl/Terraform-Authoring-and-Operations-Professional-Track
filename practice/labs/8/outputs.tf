output "plan_capture_commands" {
  description = "对比有颜色输出和无颜色输出的命令。"
  value       = local.plan_capture_commands
}

output "policy_file" {
  description = "生成的无颜色输出策略文件。"
  value       = local_file.plan_policy.filename
}

