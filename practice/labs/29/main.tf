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
  service_object = {
    name   = "payments"
    owner  = "platform"
    ports  = [8080, 9090]
    labels = { env = "dev", tier = "backend" }
  }

  encoded_service = jsonencode(local.service_object)
  decoded_service = jsondecode(file("${path.module}/data/service.json"))
}

resource "local_file" "service_json" {
  filename = "${path.module}/output/service.json"
  content  = local.encoded_service
}

output "encoded_service" {
  value = local.encoded_service
}

output "decoded_service_name" {
  value = local.decoded_service.name
}

output "decoded_skill_count" {
  value = length(local.decoded_service.skills)
}
