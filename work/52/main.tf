terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：将 service object 的 port 从 80 改为 8080。
  # 提示：测试预期 service.port 为 8080。
  service = { name = "payments", port = 80, enabled = true }
}

resource "terraform_data" "lesson" {
  input = { topic = "object 数据类型" }
}

output "service" {
  value = local.service
}


