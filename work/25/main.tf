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
  quoted_message = "最好的协作者是 Alice 和 Bob。"
  escaped_path   = "C:/terraform/training/lab25"
  multiline_text = "第一行\n第二行\n第三行"
}

resource "local_file" "escaped_strings" {
  filename = "${path.module}/output/escaped-strings.txt"
  content  = "${local.quoted_message}\n路径示例：${local.escaped_path}\n${local.multiline_text}\n"
}

output "quoted_message" {
  value = local.quoted_message
}

output "escaped_path" {
  value = local.escaped_path
}
