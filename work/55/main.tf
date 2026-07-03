terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：在 user_names 列表中添加第三个用户，使 user_count 为 3。
  # 提示：添加 "user-03" 作为第三个元素。
  user_names = ["user-01", "user-02"]
}

resource "terraform_data" "lesson" {
  input = { topic = "count 的索引挑战" }
}

output "first_user" {
  value = local.user_names[0]
}

output "user_count" {
  value = length(local.user_names)
}


