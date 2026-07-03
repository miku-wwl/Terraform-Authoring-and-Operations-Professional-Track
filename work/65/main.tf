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
  # TODO 1：将 templatefile 的 name 变量从 "TODO-service" 改为 "payments"。
  # 提示：模板输出包含服务名，测试期待渲染结果包含 "payments"。
  rendered = templatefile("${path.module}/template.tftpl", { name = "TODO-service", environment = "dev" })
}

resource "local_file" "rendered" {
  filename = "${path.module}/output/service.txt"
  content  = local.rendered
}

output "rendered" {
  value = local.rendered
}
