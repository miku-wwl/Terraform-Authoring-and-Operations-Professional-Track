output "command_catalog" {
  description = "常用 Terraform CLI help 命令。"
  value       = local.command_catalog
}

output "automation_flags" {
  description = "自动化环境中常用的 Terraform CLI 参数。"
  value       = local.automation_flags
}

output "runbook_file" {
  description = "生成的 CLI 速查文档。"
  value       = local_file.cli_runbook.filename
}

