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
#!/bin/sh
set -eu
echo "开始部署 ${path.module}"
echo "完成部署"
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
