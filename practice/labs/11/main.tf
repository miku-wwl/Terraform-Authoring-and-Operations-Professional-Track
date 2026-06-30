terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "mirror_note" {
  filename = "${path.module}/output/filesystem-mirror-note.txt"
  content  = "file system mirror 允许 Terraform 在无公网环境中从本地目录安装 provider。\n"
}

