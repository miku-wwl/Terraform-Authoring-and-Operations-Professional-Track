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

  # TODO 1：补全 plan 命令中保存文件的参数。
  # TODO 2：补全 apply 命令中指定 plan 文件的参数。
  # 提示：terraform plan -out=tfplan 保存二进制 plan，terraform apply tfplan 执行已审批的 plan。
  saved_plan_commands = [
    "terraform plan -input=false -no-color",
    "terraform show tfplan",
    "terraform show -json tfplan > plan.json",
    "terraform apply -auto-approve",
  ]
}

resource "local_file" "approved_change" {
  filename = "${path.module}/output/approved-change.txt"
  content  = local.approved_content
}

