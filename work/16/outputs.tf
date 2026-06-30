output "saved_plan_commands" {
  description = "保存、审查和应用 plan 文件的命令。"
  value       = local.saved_plan_commands
}

output "approved_file" {
  description = "通过已保存 plan 创建的文件。"
  value       = local_file.approved_change.filename
}

