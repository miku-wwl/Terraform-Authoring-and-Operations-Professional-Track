terraform {
  required_version = ">= 1.5.0"
}

variable "service_url" {
  type        = string
  description = "需要进行合约验证的服务健康检查地址。"
  default     = "https://example.com/health"
}

locals {
  service_url_uses_https = startswith(var.service_url, "https://")
}

check "service_url_contract" {
  # TODO：用 check block 在资源外表达服务 URL 合约。
  # 要求：生产服务地址必须使用 HTTPS；这个检查不属于某个资源的 lifecycle。
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
