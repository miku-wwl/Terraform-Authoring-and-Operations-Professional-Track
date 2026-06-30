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
  plan_capture_commands = {
    colored_output = "terraform plan > color.plan"
    clean_output   = "terraform plan -no-color > no-color.plan"
    ci_plan        = "terraform plan -input=false -no-color -out=tfplan"
  }
}

resource "local_file" "plan_policy" {
  filename = "${path.module}/output/no-color-policy.txt"
  content  = "CI/CD 中保存 Terraform 输出时必须使用 -no-color，避免 ANSI 控制符污染日志。\n"
}

