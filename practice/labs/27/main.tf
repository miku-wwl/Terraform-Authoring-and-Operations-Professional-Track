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

  indented_heredoc = <<-EOT
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
