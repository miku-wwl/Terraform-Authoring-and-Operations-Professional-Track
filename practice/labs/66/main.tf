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
  services = { api = 8080, worker = 9000 }
  rendered = templatefile("${path.module}/template.tftpl", { services = local.services })
}

resource "local_file" "rendered" {
  filename = "${path.module}/output/services.txt"
  content  = local.rendered
}

output "rendered" {
  value = local.rendered
}
