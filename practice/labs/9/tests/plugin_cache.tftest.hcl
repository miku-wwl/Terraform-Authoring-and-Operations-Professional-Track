run "plugin_cache_is_documented" {
  command = plan

  assert {
    condition     = strcontains(output.plugin_cache_dir, ".terraform-plugin-cache")
    error_message = "实验必须定义独立的 plugin cache 目录。"
  }

  assert {
    condition     = contains(output.cache_commands, "terraform init -input=false")
    error_message = "实验必须包含可重复执行的 init 命令。"
  }
}

