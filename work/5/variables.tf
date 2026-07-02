variable "service_name" {
  description = "由自动化工作流管理的应用或平台服务名称。"
  type        = string
  default     = "payments-api"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}$", var.service_name))
    error_message = "service_name 必须为 3 到 31 个字符，以字母开头，并且只能包含小写字母、数字或连字符。"
  }
}

variable "environment" {
  description = "自动化工作流要部署的目标环境。"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment 必须是 dev、stage、prod 之一。"
  }
}

variable "approver_groups" {
  description = "允许在 apply 前审批已保存 Terraform plan 的用户组。"
  type        = list(string)
  default     = ["platform-owners"]

  validation {
    condition     = length(var.approver_groups) > 0
    error_message = "至少需要一个审批用户组。"
  }
}
