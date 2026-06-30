terraform {
  required_version = ">= 1.5.0"
}

variable "api_token" {
  type        = string
  description = "模拟 API token。"
  sensitive   = true
  default     = "local-token-123456"
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
