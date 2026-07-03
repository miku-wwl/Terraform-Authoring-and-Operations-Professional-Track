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
  mirror_summary = <<-EOT
  file system mirror 允许 Terraform 在无公网环境中从本地目录安装 provider。
  关键流程是先执行 terraform providers mirror 生成 mirror 目录，
  再通过 TF_CLI_CONFIG_FILE 指向 terraform-cli.rc，让 terraform init 从 mirror 安装 provider。
  EOT
}

resource "local_file" "mirror_note" {
  filename = "${path.module}/output/filesystem-mirror-note.txt"
  content  = local.mirror_summary
}
