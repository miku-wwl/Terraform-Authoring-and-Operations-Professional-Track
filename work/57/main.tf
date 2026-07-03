terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：在 service_files map 中添加第二个服务，使 service_count 为 2。
  # 提示：添加 worker = "worker service" 作为第二个 key-value。
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


