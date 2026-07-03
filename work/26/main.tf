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
  # TODO 1：补充脚本 shebang（#!/bin/sh）。
  # TODO 2：补充完成部署的提示文本。
  # 提示：heredoc 用 <<EOT ... EOT 包裹多行内容，shebang 是 #!/bin/sh。
  deploy_script = <<EOT
# TODO：补充脚本 shebang
set -eu
echo "开始部署 ${path.module}"
echo "TODO：补充完成部署提示"
EOT
}

resource "local_file" "deploy_script" {
  filename        = "${path.module}/output/deploy.sh"
  content         = local.deploy_script
  file_permission = "0755"
}

output "script_preview" {
  value = local.deploy_script
}
