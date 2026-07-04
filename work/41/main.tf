terraform {
  required_version = ">= 1.5.0"
}

variable "service_url" {
  type        = string
  description = "需要进行合约验证的服务健康检查地址。"
  # TODO 1：把默认服务地址改成 HTTPS。
  # 提示：测试要求 output.service_url 以 https:// 开头。
  default = "http://example.com/health"
}

locals {
  # TODO 2：补全资源外合约判断，确认 service_url 使用 HTTPS。
  # 提示：用 startswith(var.service_url, "https://") 返回 true/false。
  service_url_uses_https = false
}

check "service_url_contract" {
  # check block 不属于某个 resource 的 lifecycle，它表达的是模块整体合约。
  assert {
    condition     = local.service_url_uses_https
    error_message = "生产服务地址必须使用 https。"
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

output "service_url_contract_ok" {
  value = local.service_url_uses_https
}
