terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：补充 CI/CD 中工具版本固定的提醒。
  # 提示：生产 CI 不要长期使用 latest 标签，应固定镜像版本。
  checkov_installation_notes = [
    "生产环境可以在专用镜像或工具容器中预装 Checkov",
    "本实验使用 bridgecrew/checkov 容器，避免污染宿主机",
    "TODO：补充 CI/CD 中工具版本固定的提醒",
  ]
}

output "checkov_installation_notes" {
  description = "Checkov 安装与运行方式说明。"
  value       = local.checkov_installation_notes
}

