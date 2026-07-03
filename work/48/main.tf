terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

resource "local_file" "critical_config" {
  filename = "${path.module}/output/critical-config.txt"
  content  = "受 prevent_destroy 保护的关键配置。\n"

  # TODO 1：在 lifecycle 中添加 prevent_destroy = true。
  # 提示：prevent_destroy 阻止 terraform destroy 销毁此资源。
  lifecycle {
  }
}

# TODO 2：补充受保护资源的完整地址。
# 提示：资源地址格式为 资源类型.资源名。
output "protected_resource" {
  value = "TODO：补充受保护资源地址"
}

# TODO 3：补全 state 清理命令。
# 提示：用 terraform state rm 从 state 中移除资源再删除本地文件。
output "cleanup_command" {
  value = "TODO：补充 state 清理命令 && rm -f output/critical-config.txt"
}
