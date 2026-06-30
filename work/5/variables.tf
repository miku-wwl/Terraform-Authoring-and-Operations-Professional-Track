variable "service_name" {
  description = "由自动化工作流管理的应用或平台服务名称。"
  type        = string
  default     = "payments-api"

  # TODO：添加 validation，要求服务名以小写字母开头，只包含小写字母、数字或连字符。
}

variable "environment" {
  description = "自动化工作流要部署的目标环境。"
  type        = string
  default     = "dev"

  # TODO：添加 validation，只允许 dev、stage、prod。
}

variable "approver_groups" {
  description = "允许在 apply 前审批已保存 Terraform plan 的用户组。"
  type        = list(string)
  default     = ["platform-owners"]

  # TODO：添加 validation，至少需要一个审批用户组。
}

