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
  # TODO 1：补充变量验证发生的阶段。
  # 提示：变量验证在 plan 阶段执行，把错误前移，避免 apply 时才失败。
  validation_purpose = "TODO：补充变量验证发生的阶段。"
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
