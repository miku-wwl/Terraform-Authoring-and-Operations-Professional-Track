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
  command_catalog = {
    init_help     = "terraform init -help"
    plan_help     = "terraform plan -help"
    apply_help    = "terraform apply -help"
    validate_help = "terraform validate -help"
  }

  automation_flags = {
    input_false      = "-input=false"
    no_color         = "-no-color"
    saved_plan       = "-out=tfplan"
    detail_exit_code = "-detailed-exitcode"
  }
}

resource "local_file" "cli_runbook" {
  filename = "${path.module}/output/terraform-cli-runbook.md"
  content = templatefile("${path.module}/templates/cli-runbook.tftpl", {
    command_catalog  = local.command_catalog
    automation_flags = local.automation_flags
  })
}

