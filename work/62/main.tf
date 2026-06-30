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
  files = { for row in csvdecode(file("${path.module}/data/files.csv")) : row.name => row if row.name == "api" }
}

resource "local_file" "generated" {
  for_each = local.files

  filename = "${path.module}/output/${each.key}.txt"
  content  = "${each.value.content}\n"
}

output "generated_files" {
  value = keys(local_file.generated)
}
