terraform {
  required_version = ">= 1.5.0"
}

locals {
  checkov_installation_notes = [
    "生产环境可以在专用镜像或工具容器中预装 Checkov",
    "本实验使用 bridgecrew/checkov 容器，避免污染宿主机",
    "TODO：补充 CI/CD 工具版本固定策略",
  ]
}

output "checkov_installation_notes" {
  description = "Checkov 安装与运行方式说明。"
  value       = local.checkov_installation_notes
}

