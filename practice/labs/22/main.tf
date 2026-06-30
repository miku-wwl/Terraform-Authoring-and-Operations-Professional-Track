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

resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

locals {
  artifact_name = "training-artifact-${random_integer.suffix.result}"
}

resource "local_file" "artifact" {
  filename = "${path.module}/output/${local.artifact_name}.txt"
  content  = "使用 random_integer 生成唯一后缀：${random_integer.suffix.result}\n"
}

output "random_suffix" {
  value = random_integer.suffix.result
}

output "artifact_name" {
  value = local.artifact_name
}
