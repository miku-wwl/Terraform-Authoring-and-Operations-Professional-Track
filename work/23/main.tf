terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

resource "random_integer" "build_number" {
  min = 100
  max = 999
}

resource "local_file" "manifest" {
  filename = "${path.module}/output/manifest-${random_integer.build_number.result}.txt"
  content  = "manifest 依赖 build_number=${random_integer.build_number.result}\n"
}

locals {
  dependency_rule = "TODO：补充 target 与依赖方向的规则。"
}

output "dependency_rule" {
  value = local.dependency_rule
}

output "manifest_filename" {
  value = local_file.manifest.filename
}
