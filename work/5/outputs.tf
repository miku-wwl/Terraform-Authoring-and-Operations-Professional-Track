output "generated_files" {
  description = "本地自动化工作流模拟实验生成的文件。"
  value = [
    local_file.release_manifest.filename,
    local_file.approval_note.filename,
  ]
}

output "pipeline_commands" {
  description = "适合 CI/CD runner 使用的非交互式 Terraform 命令。"
  value       = local.pipeline_commands
}

