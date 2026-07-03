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
  approved_content = "这是保存 plan 时已经审批过的内容。\n"
  saved_plan_commands = [
    "terraform plan -input=false -no-color -out=tfplan",
    "terraform show tfplan",
    "terraform show -json tfplan > plan.json",
    "terraform apply -auto-approve tfplan",
  ]
}

resource "local_file" "approved_change" {
  filename = "${path.module}/output/approved-change.txt"
  content  = local.approved_content
}

