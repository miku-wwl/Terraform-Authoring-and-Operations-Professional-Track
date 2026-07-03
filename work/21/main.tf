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
  # TODO 1：补全 targeted plan 命令中的资源地址。
  # TODO 2：补全资源总数（本目录有 2 个 local_file 资源）。
  # 提示：-target=local_file.release_note 指定只针对该资源执行 plan。
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
  value = 1 # TODO 2：改成正确的资源总数
}
