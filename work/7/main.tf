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

  automation_commands = [
    "terraform init -input=false",
    "terraform plan -input=false -var artifact_name=ci-artifact.txt -out=tfplan",
    "terraform apply -auto-approve tfplan",
  ]
}

resource "local_file" "artifact" {
  filename = "${path.module}/output/${var.artifact_name}"
  content  = "非交互式 Terraform 流水线产物：${var.artifact_name}\n"
}
