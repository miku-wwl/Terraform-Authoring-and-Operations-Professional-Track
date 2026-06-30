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

  lifecycle {
    prevent_destroy = true
  }
}

output "protected_resource" {
  value = "TODO：补充受保护资源地址"
}

output "cleanup_command" {
  value = "TODO：补充 state 清理命令 && rm -f output/critical-config.txt"
}
