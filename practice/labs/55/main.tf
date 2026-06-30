terraform {
  required_version = ">= 1.5.0"
}

locals {
  user_names = ["user-01", "user-02", "user-03"]
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


