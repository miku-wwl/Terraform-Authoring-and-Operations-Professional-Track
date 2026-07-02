output "implementation_steps" {
  description = "落地 provider plugin cache 的步骤。"
  value       = local.implementation_steps
}

output "terraform_rc_content" {
  description = "Terraform CLI 配置文件内容，用于检查 plugin cache 配置。"
  value       = local.terraform_rc
}

output "terraform_rc_example" {
  description = "生成的 Terraform CLI 配置示例。"
  value       = local_file.terraform_rc_example.filename
}
