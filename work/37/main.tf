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
  input = {
    min_length = 8
    accepted   = length(var.db_password) >= 12
  }
}

output "password_policy" {
  value = terraform_data.password_policy.output
}
