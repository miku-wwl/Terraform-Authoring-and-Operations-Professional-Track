terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "lock_note" {
  filename = "${path.module}/output/lock-note.txt"
  content  = "terraform init 会生成 .terraform.lock.hcl，用于锁定 provider 选择结果。\n"
}

output "lock_file_name" {
  value = ".terraform.lock.hcl"
}

output "provider_constraint" {
  value = "~> 2.5"
}
