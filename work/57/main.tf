terraform {
  required_version = ">= 1.5.0"
}

locals {
  service_files = { api = "api service" }
}

resource "terraform_data" "lesson" {
  input = { topic = "for_each 基础" }
}

output "service_keys" {
  value = keys(local.service_files)
}

output "service_count" {
  value = length(local.service_files)
}


