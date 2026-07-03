terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "managed_note" {
  filename = "${path.module}/output/managed-note.txt"
  content  = "Terraform 管理的基线内容。\n"

  # TODO 1：在 lifecycle 中添加 ignore_changes = [content]。
  # 提示：ignore_changes 让 Terraform 忽略 content 的外部漂移。
  lifecycle {
  }
}

# TODO 2：补充被忽略的属性名称。
# 提示：ignore_changes 列表中忽略了哪个属性？
output "ignored_attribute" {
  value = "TODO：补充被忽略的属性"
}

output "managed_file" {
  value = local_file.managed_note.filename
}
