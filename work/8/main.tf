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
  # TODO 1：保存给工具解析的 plan 文本时，不应该保留颜色控制符。
  # 提示：把 clean_output 改成适合重定向到 no-color.plan 的命令。
  #
  # TODO 2：CI/CD 中的 plan 命令需要同时满足三点：
  # - 禁用交互输入，避免流水线 hang
  # - 禁用颜色输出，避免 ANSI 控制符污染日志
  # - 保存二进制 plan 文件，供 apply 使用
  plan_capture_commands = {
    colored_output = "terraform plan > color.plan"
    clean_output   = "terraform plan > no-color.plan"
    ci_plan        = "terraform plan -out=tfplan"
  }
}

resource "local_file" "plan_policy" {
  filename = "${path.module}/output/no-color-policy.txt"
  content  = "CI/CD 中保存 Terraform 输出时必须使用 -no-color，避免 ANSI 控制符污染日志。\n"
}
