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
  # TODO 1：CI/CD 中 init 不能等待交互输入，请给 init 命令补充禁用交互输入的参数。
  # 提示：目标命令应该体现 “不要让流水线 hang 在交互式 prompt 上”。
  #
  # TODO 2：plan 也必须禁用交互输入，并且显式传入 artifact_name。
  # 提示：本题不依赖 terraform.tfvars 自动加载变量，而是练习在命令中使用 -var。
  #
  # TODO 3：plan 需要保存成 tfplan，后续 apply 使用同一个已保存 plan。
  automation_commands = [
    "terraform init",
    "terraform plan -out=tfplan",
    "terraform apply -auto-approve tfplan",
  ]
}

resource "local_file" "artifact" {
  filename = "${path.module}/output/${var.artifact_name}"
  content  = "非交互式 Terraform 流水线产物：${var.artifact_name}\n"
}
