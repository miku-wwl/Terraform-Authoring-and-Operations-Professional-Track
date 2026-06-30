output "automation_commands" {
  description = "适合自动化环境的非交互式命令。"
  value       = local.automation_commands
}

output "artifact_file" {
  description = "生成的本地文件。"
  value       = local_file.artifact.filename
}

