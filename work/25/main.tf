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
  # TODO 1：在 Alice 和 Bob 两侧添加转义双引号 \"。
  # TODO 2：将路径中的斜杠改为转义反斜杠 \\。
  # 提示：Terraform 双引号字符串中用 \" 保留双引号，用 \\ 保留反斜杠。
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
