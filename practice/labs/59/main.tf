terraform {
  required_version = ">= 1.5.0"
}

locals {
  users       = ["alice", "bob", "john"]
  upper_users = [for user in local.users : upper(user)]
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


