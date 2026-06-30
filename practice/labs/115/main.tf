terraform {
  required_version = ">= 1.5.0"
}

locals {
  debug_steps = [
    "复现问题",
    "提高日志级别",
    "定位 provider 或 core 行为",
    "收敛最小复现",
    "修复后再次验证",
  ]
}

resource "terraform_data" "debugging" {
  input = {
    env_vars = ["TF_LOG", "TF_LOG_PATH"]
    steps    = local.debug_steps
  }
}

output "debug_env_vars" {
  value = terraform_data.debugging.output.env_vars
}

output "debug_step_count" {
  value = length(terraform_data.debugging.output.steps)
}
