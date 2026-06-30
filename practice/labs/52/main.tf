terraform {
  required_version = ">= 1.5.0"
}

locals {
  service = { name = "payments", port = 8080, enabled = true }
}

resource "terraform_data" "lesson" {
  input = { topic = "object 数据类型" }
}

output "service" {
  value = local.service
}


