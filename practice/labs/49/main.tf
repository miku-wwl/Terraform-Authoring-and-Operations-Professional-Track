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

  lifecycle {
    ignore_changes = [
      content,
    ]
  }
}

output "ignored_attribute" {
  value = "content"
}

output "managed_file" {
  value = local_file.managed_note.filename
}
