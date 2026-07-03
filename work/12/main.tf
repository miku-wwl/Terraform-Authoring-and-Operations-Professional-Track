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
  # TODO 1：补充 air-gapped 环境下 direct 回退的边界说明。
  # 提示：本节核心是 provider_installation 显式控制安装源。
  # mirror 优先，direct 仅作为联网环境回退；air-gapped 环境不要配置 direct 回退。
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

