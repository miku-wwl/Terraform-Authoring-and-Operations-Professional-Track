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
  automation_environment = {
    linux_macos = "TODO：补充 Linux/macOS 设置方式"
    powershell  = "TODO：补充 PowerShell 设置方式"
    cmd         = "set TF_IN_AUTOMATION=true"
  }
}

resource "local_file" "automation_log_policy" {
  filename = "${path.module}/output/tf-in-automation-policy.txt"
  content  = "在 CI/CD 中设置 TF_IN_AUTOMATION=true，减少不必要的下一步提示，让日志更适合排障。\n"
}

