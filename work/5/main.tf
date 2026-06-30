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
  # TODO：把这些命令改造成适合 CI/CD 的非交互式 Terraform 命令。
  pipeline_commands = [
    "terraform init",
    "terraform fmt",
    "terraform validate",
    "terraform plan",
    "terraform apply",
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
    plan_command    = local.pipeline_commands[3]
    apply_command   = local.pipeline_commands[4]
  })
}

