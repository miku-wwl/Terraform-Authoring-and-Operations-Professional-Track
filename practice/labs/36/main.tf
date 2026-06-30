terraform {
  required_version = ">= 1.5.0"
}

variable "workspace_name" {
  type        = string
  description = "工作区名称，只允许小写字母、数字和连字符。"
  default     = "team-dev-01"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.workspace_name))
    error_message = "workspace_name 只能包含小写字母、数字和连字符。"
  }
}

locals {
  validation_purpose = "把命名错误前移到 plan 阶段，避免 apply 时才被远端 API 拒绝。"
}

resource "terraform_data" "workspace" {
  input = {
    name = var.workspace_name
  }
}

output "workspace_name" {
  value = terraform_data.workspace.output.name
}

output "validation_purpose" {
  value = local.validation_purpose
}
