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
