terraform {
  required_version = ">= 1.5.0"
}

variable "image_version" {
  type        = string
  description = "模拟不可原地更新的镜像版本。"
  default     = "v1"
}

resource "terraform_data" "service_release" {
  input = {
    image_version = var.image_version
  }

  triggers_replace = [
    var.image_version
  ]

  # TODO 1：在 lifecycle 中添加 create_before_destroy = true。
  # 提示：create_before_destroy 先创建替代对象再销毁旧对象，减少中断。
  lifecycle {
  }
}

output "image_version" {
  value = terraform_data.service_release.output.image_version
}

# TODO 2：补充替换策略的名称。
# 提示：当前 lifecycle 使用的策略是 create_before_destroy。
output "replacement_strategy" {
  value = "TODO：补充替换策略"
}
