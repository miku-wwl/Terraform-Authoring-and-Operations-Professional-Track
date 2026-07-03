terraform {
  required_version = ">= 1.5.0"
}

locals {
  users       = ["alice", "bob", "john"]
  # TODO 1：用 for 表达式将 users 列表中的每个元素转为大写。
  # 提示：[for user in local.users : upper(user)] 会将每个名字转为大写。
  upper_users = local.users
}

resource "terraform_data" "lesson" {
  input = { topic = "for 表达式基础" }
}

output "upper_users" {
  value = local.upper_users
}

output "user_count" {
  value = length(local.upper_users)
}


