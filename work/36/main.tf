terraform {
  required_version = ">= 1.5.0"
}

variable "workspace_name" {
  type        = string
  description = "工作区名称，只允许小写字母、数字和连字符。"
  default     = "team-dev-01"

  # 参考：这是一个完整的 validation 规则。regex + can 判断名称是否合法。
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.workspace_name))
    error_message = "workspace_name 只能包含小写字母、数字和连字符。"
  }
}

variable "environment" {
  type        = string
  description = "部署环境"
  default     = "dev"

  # TODO 1：为 environment 写 validation 规则，只允许 "dev"、"staging"、"prod"。
  # 提示：contains(["dev", "staging", "prod"], var.environment) 做白名单校验。
  validation {
    condition     = "TODO：限制 environment 只能为 dev/staging/prod"
    error_message = "TODO：environment 只能是 dev、staging 或 prod"
  }
}

variable "instance_count" {
  type        = number
  description = "实例数量，范围 1-10。"
  default     = 3

  # TODO 2：为 instance_count 写 validation 规则，限制在 1 到 10 之间。
  # 提示：var.instance_count >= 1 && var.instance_count <= 10 做范围校验。
  validation {
    condition     = "TODO：限制 instance_count 在 1-10 范围内"
    error_message = "TODO：instance_count 必须在 1 到 10 之间"
  }
}

resource "terraform_data" "workspace" {
  input = {
    name           = var.workspace_name
    environment    = var.environment
    instance_count = var.instance_count
  }
}

output "workspace_name" {
  value = terraform_data.workspace.output.name
}

output "environment" {
  value = terraform_data.workspace.output.environment
}

output "instance_count" {
  value = terraform_data.workspace.output.instance_count
}
