terraform {
  required_version = ">= 1.5.0"
}

variable "db_password" {
  type        = string
  description = "数据库密码"
  default     = "ChangeMe12345"

  sensitive = true
  validation {
    condition     = length(var.db_password) >= 12
    error_message = "密码长度不足12"
  }
}

resource "terraform_data" "password_policy" {
  input = {
    min_length = 12
    accepted = length(var.db_password) >= 12
  }
}

output "password_policy" {
  value     = terraform_data.password_policy.output
  sensitive = true
}
