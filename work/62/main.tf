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
  # TODO 1：移除 for 表达式中的 if row.name == "api" 过滤条件，使所有 CSV 行都生成文件。
  # 提示：CSV 有两行 api 和 worker，去掉过滤后 length == 2。
  files = { for row in csvdecode(file("${path.module}/data/files.csv")) : row.name => row if row.name == "api" }
}

resource "local_file" "generated" {
  for_each = local.files

  filename = "${path.module}/output/${each.key}.txt"
  content  = "${each.value.content}\n"
}

output "generated_files" {
  value = keys(local_file.generated)
}
