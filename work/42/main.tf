terraform {
  required_version = ">= 1.5.0"
}

variable "api_token" {
  type        = string
  description = "模拟 API token。"
  # TODO 1：给 api_token 设置一个非空的默认值，使 token_is_configured 为 true。
  # TODO 2：将 api_token 标记为 sensitive，避免在 plan 输出中明文显示。
  # 提示：sensitive = true 可隐藏敏感值，默认值可设为 "local-token-123456"。
  default     = ""
}

resource "terraform_data" "secret_metadata" {
  input = {
    token_length = length(var.api_token)
    token_set    = var.api_token != ""
  }
}

output "token_is_configured" {
  value = terraform_data.secret_metadata.output.token_set
}

output "api_token" {
  value     = var.api_token
  sensitive = true
}
