terraform {
  required_version = ">= 1.5.0"
}

variable "service_url" {
  type        = string
  description = "需要检查的服务地址。"
  # TODO 1：将默认 URL 的协议从 http 改为 https。
  # 提示：测试要求 output 以 https:// 开头。
  default     = "http://example.com/health"
}

check "service_url_contract" {
  # TODO 2：将检查条件从 http 改为 https。
  # 提示：startswith 检查 URL 前缀，生产环境应强制 https。
  assert {
    condition     = startswith(var.service_url, "http://")
    error_message = "生产服务地址必须使用 http。"
  }
}

resource "terraform_data" "service_contract" {
  input = {
    url = var.service_url
  }
}

output "service_url" {
  value = terraform_data.service_contract.output.url
}
