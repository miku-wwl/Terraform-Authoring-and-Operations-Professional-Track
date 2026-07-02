output "mirror_note" {
  description = "生成的 file system mirror 说明文件。"
  value       = local_file.mirror_note.filename
}

output "cli_config_content" {
  description = "Terraform CLI provider_installation 配置内容。"
  value       = file("${path.module}/terraform-cli.rc")
}
