terraform {
  required_version = ">= 1.5.0"
}

variable "instance_size" {
  type        = string
  description = "本地模拟的实例规格。"
  default     = "small"
}

resource "terraform_data" "compute_request" {
  input = {
    size = var.instance_size
  }

  lifecycle {
    # TODO 1：写 precondition，限制 instance_size 只能是 small 或 medium。
    # 提示：precondition 在资源评估前执行，用 var.instance_size 访问变量值。
    #       用 contains(["small", "medium"], var.instance_size) 做白名单校验。
    precondition {
      condition     = "TODO：限制规格在 small/medium 白名单内"
      error_message = "TODO：不合法规格的错误提示"
    }

    # TODO 2：写 postcondition，确认 self.output.size 仍在允许范围内。
    # 提示：postcondition 在资源创建后执行，self 指向当前资源。
    #       self.output.size 取出资源输出中的 size 字段。
    postcondition {
      condition     = "TODO：确认输出规格仍在允许范围内"
      error_message = "TODO：输出校验失败的错误提示"
    }
  }
}

output "compute_size" {
  value = terraform_data.compute_request.output.size
}
