terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

locals {
  # TODO 1：在 services map 中添加 api = 8080，使模板渲染包含 "api: 8080"。
  # 提示：模板用 %{ for name, port in services ~} 遍历 map 的所有 key-value。
  services = { worker = 9000 }
  rendered = templatefile("${path.module}/template.tftpl", { services = local.services })
}

resource "local_file" "rendered" {
  filename = "${path.module}/output/services.txt"
  content  = local.rendered
}

output "rendered" {
  value = local.rendered
}
