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
  basic_heredoc = <<EOT
    line-one
      line-two
    line-three
EOT

  # TODO 1：将 indented heredoc 的 <<EOT 改为 <<-EOT，使其移除共同前导空白。
  # 提示：基础 heredoc（<<EOT）保留前导空白，indented heredoc（<<-EOT）去掉共同缩进。
  indented_heredoc = <<EOT
    line-one
      line-two
    line-three
  EOT
}

resource "local_file" "basic" {
  filename = "${path.module}/output/basic.txt"
  content  = local.basic_heredoc
}

resource "local_file" "indented" {
  filename = "${path.module}/output/indented.txt"
  content  = local.indented_heredoc
}

output "basic_heredoc" {
  value = local.basic_heredoc
}

output "indented_heredoc" {
  value = local.indented_heredoc
}
