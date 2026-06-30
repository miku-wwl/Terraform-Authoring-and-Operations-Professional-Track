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
  rendered = templatefile("${path.module}/template.tftpl", { name = "payments", environment = "dev" })
}

resource "local_file" "rendered" {
  filename = "${path.module}/output/service.txt"
  content  = local.rendered
}

output "rendered" {
  value = local.rendered
}
