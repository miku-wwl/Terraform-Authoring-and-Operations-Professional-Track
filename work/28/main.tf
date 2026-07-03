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
  # TODO 1：在 name: payments 前增加两个空格，使其相对 app: 缩进。
  # 提示：<<-EOT 移除共同前导空白，但保留各行之间的相对缩进。
  uneven_indented = <<-EOT
      app:
      name: payments
      env: prod
  EOT

  rendered_lines = split("\n", trimspace(local.uneven_indented))
}

resource "local_file" "whitespace_demo" {
  filename = "${path.module}/output/whitespace-demo.yaml"
  content  = local.uneven_indented
}

output "first_line" {
  value = local.rendered_lines[0]
}

output "second_line" {
  value = local.rendered_lines[1]
}

output "line_count" {
  value = length(local.rendered_lines)
}
