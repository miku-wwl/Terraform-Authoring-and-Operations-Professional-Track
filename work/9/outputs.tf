output "plugin_cache_dir" {
  description = "共享 provider plugin 缓存目录。"
  value       = local.plugin_cache_dir
}

output "cache_commands" {
  description = "启用 plugin cache 的命令。"
  value       = local.cache_commands
}

output "policy_file" {
  description = "生成的 plugin cache 策略文档。"
  value       = local_file.cache_policy.filename
}

