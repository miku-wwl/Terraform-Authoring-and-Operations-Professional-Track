terraform {
  required_version = ">= 1.5.0"
}

locals {
  raw_names    = ["api", "worker", "api"]
  unique_names = toset(local.raw_names)
}

resource "terraform_data" "lesson" {
  input = { topic = "set 数据类型" }
}

output "unique_names" {
  value = local.unique_names
}

output "unique_count" {
  value = length(local.unique_names)
}


