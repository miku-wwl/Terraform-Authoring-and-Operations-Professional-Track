terraform {
  required_version = ">= 1.5.0"
}

variable "service_url" {
  type        = string
  description = "需要进行合约验证的服务健康检查地址。"
  default     = "https://example.com/health"
}

locals {
  # TODO 1：补全资源外合约判断，确认 service_url 使用 HTTPS。
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
  # TODO 2：输出同一个合约检查结果，方便 terraform test 验收。
  # 提示：这里应该引用上面的 local.service_url_uses_https。
  value = false
}
