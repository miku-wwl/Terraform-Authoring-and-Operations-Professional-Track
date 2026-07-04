terraform {
  required_version = ">= 1.5.0"
}

variable "db_password" {
  type        = string
  description = "数据库密码"
  default     = "ChangeMe12345"

  sensitive = true

  # TODO 2：写 validation 规则，用 length() 要求密码至少 12 位。
  # 提示：length(var.db_password) >= 12
  validation {
    condition     = length(var.db_password) >= 12
    error_message = "密码长度不足12"
  }
}

resource "terraform_data" "password_policy" {
  input = {
    min_length = 12
    # TODO 3：用 length() 判断当前密码是否满足 >= 12 位。
    # 提示：和 validation 的 condition 表达式一样。
    accepted = length(var.db_password) >= 12
  }
}

output "password_policy" {
  value     = terraform_data.password_policy.output
  sensitive = true
}
