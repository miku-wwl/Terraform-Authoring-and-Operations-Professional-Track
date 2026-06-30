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
  target_commands = [
    "terraform plan",
    "terraform apply -target=local_file.release_note -auto-approve",
    "terraform destroy -target=local_file.release_note -auto-approve",
  ]
}

resource "local_file" "release_note" {
  filename = "${path.module}/output/release-note.txt"
  content  = "只针对发布说明执行 targeted apply。\n"
}

resource "local_file" "runbook" {
  filename = "${path.module}/output/runbook.txt"
  content  = "常规 apply 会创建本目录中的所有资源。\n"
}

output "target_commands" {
  value = local.target_commands
}

output "resource_count" {
  value = 1
}
