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
  # TODO 1：补充 Linux/macOS 中设置 TF_IN_AUTOMATION 的方式。
  # TODO 2：补充 PowerShell 中设置 TF_IN_AUTOMATION 的方式。
  # 提示：Linux/macOS 用 export，PowerShell 用 $env: 变量语法。
  automation_environment = {
    linux_macos = "export TF_IN_AUTOMATION=true"
    powershell  = "$env:TF_IN_AUTOMATION='true'"
    cmd         = "set TF_IN_AUTOMATION=true"
  }
}

resource "local_file" "automation_log_policy" {
  filename = "${path.module}/output/tf-in-automation-policy.txt"
  content  = "在 CI/CD 中设置 TF_IN_AUTOMATION=true，减少不必要的下一步提示，让日志更适合排障。\n"
}

