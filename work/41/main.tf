terraform {
  required_version = ">= 1.5.0"
}

variable "service_url" {
  type        = string
  description = "需要检查的服务地址。"
  default     = "http://example.com/health"
}

check "service_url_contract" {
  assert {
    condition     = startswith(var.service_url, "https://")
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
