terraform {
  required_version = ">= 1.5.0"
}

variable "api_token" {
  type        = string
  description = "模拟由 CI 或 tfvars 注入的 API token。"
  # TODO 1：将 api_token 标记为 sensitive，减少 plan/apply/output 中的明文泄露。
  # 提示：这里练的是 sensitive = true；不要把真实 token 硬编码进 Terraform 文件。
  default = ""
}

locals {
  # TODO 2：只暴露非敏感派生状态，不输出 token 原文。
  # 提示：用 nonsensitive(length(trimspace(var.api_token)) > 0) 得到安全的 boolean。
  token_is_configured = false
}

resource "terraform_data" "secret_metadata" {
  input = {
    token_set          = local.token_is_configured
    state_risk_message = "sensitive hides CLI output only; protect tfstate and saved plan files."
  }
}

output "token_is_configured" {
  value = terraform_data.secret_metadata.output.token_set
}

output "api_token" {
  # TODO 3：敏感值如果必须输出，也要显式标记为 sensitive。
  # 提示：如果 output 直接引用 var.api_token，就必须设置 sensitive = true。
  value     = var.api_token
  sensitive = false
}

output "state_risk_message" {
  value = terraform_data.secret_metadata.output.state_risk_message
}
