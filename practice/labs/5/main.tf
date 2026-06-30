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
  pipeline_commands = [
    "terraform init -input=false",
    "terraform fmt -check",
    "terraform validate",
    "terraform plan -input=false -no-color -out=tfplan",
    "terraform apply -auto-approve tfplan",
  ]

  release_manifest = {
    service         = var.service_name
    environment     = var.environment
    approver_groups = var.approver_groups
    workflow        = "automation"
    commands        = local.pipeline_commands
  }
}

resource "local_file" "release_manifest" {
  filename = "${path.module}/output/${var.environment}-${var.service_name}-release.json"
  content  = jsonencode(local.release_manifest)
}

resource "local_file" "approval_note" {
  filename = "${path.module}/output/${var.environment}-${var.service_name}-approval.txt"
  content = templatefile("${path.module}/templates/approval-note.tftpl", {
    service         = var.service_name
    environment     = var.environment
    approver_groups = join(", ", var.approver_groups)
    plan_command    = "terraform plan -input=false -no-color -out=tfplan"
    apply_command   = "terraform apply -auto-approve tfplan"
  })
}

