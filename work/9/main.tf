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
  # TODO 1：把缓存目录改成当前 module 下的 .terraform-plugin-cache。
  # 提示：provider plugin cache 是给多个 init 复用 provider 包的目录，不是 .terraform 工作目录。
  plugin_cache_dir = "${path.module}/TODO-plugin-cache"

  # TODO 2：init 命令要适合 CI/CD，需要禁用交互输入。
  # 提示：本题不是让你真的在 Terraform 里设置环境变量，而是生成一份 cache 策略文档。
  #
  # TODO 3：保留两次 init 命令，用来表达“第一次下载，第二次复用缓存”的训练目标。
  cache_commands = [
    "mkdir -p .terraform-plugin-cache",
    "export TF_PLUGIN_CACHE_DIR=${local.plugin_cache_dir}",
    "terraform init",
    "terraform init",
  ]
}

resource "local_file" "cache_policy" {
  filename = "${path.module}/output/plugin-cache-policy.md"
  content = templatefile("${path.module}/templates/plugin-cache-policy.tftpl", {
    plugin_cache_dir = local.plugin_cache_dir
    cache_commands   = local.cache_commands
  })
}
