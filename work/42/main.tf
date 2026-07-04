terraform {
  required_version = ">= 1.5.0"
}

variable "api_token" {
  type        = string
  description = "模拟由 CI 或 tfvars 注入的 API token。"
  default     = "x"
  sensitive   = true
}

locals {
  token_is_configured = nonsensitive(length(trimspace(var.api_token)) > 0)
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
  value     = var.api_token
  sensitive = true
}

output "state_risk_message" {
  value = terraform_data.secret_metadata.output.state_risk_message
}
