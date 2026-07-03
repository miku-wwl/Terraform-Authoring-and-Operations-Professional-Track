terraform {
  required_version = ">= 1.5.0"
}

variable "db_password" {
  type        = string
  description = "数据库密码，至少 12 位。"
  sensitive   = true
  default     = "ChangeMe12345"

  validation {
    condition     = length(var.db_password) >= 12
    error_message = "db_password 长度必须至少为 12。"
  }
}

resource "terraform_data" "password_policy" {
  # TODO 1：将 min_length 从 8 改为 12，与验证规则保持一致。
  # 提示：密码 validation 要求 >= 12 位，策略记录应与验证一致。
  input = {
    min_length = 8
    accepted   = length(var.db_password) >= 12
  }
}

output "password_policy" {
  value = terraform_data.password_policy.output
}
