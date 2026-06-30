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
  provider_installation_policy = [
    "filesystem_mirror 优先从本地 mirror 安装 provider",
    "direct 可以作为允许联网环境的回退方式",
    "TODO：补充离线环境 direct 回退边界",
  ]
}

resource "local_file" "provider_installation_policy" {
  filename = "${path.module}/output/provider-installation-policy.txt"
  content  = join("\n", local.provider_installation_policy)
}

