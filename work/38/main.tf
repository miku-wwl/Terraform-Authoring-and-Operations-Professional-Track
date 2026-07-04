terraform {
  required_version = ">= 1.5.0"
}

variable "instance_size" {
  type        = string
  description = "本地模拟的实例规格。"
  default     = "small"

  # TODO 1：用 contains() 限制 instance_size 只能是 small、medium、large。
  # 提示：contains(["small", "medium", "large"], var.instance_size)
  validation {
    condition     = "TODO：限制 instance_size 在白名单内"
    error_message = "TODO：不合法规格的错误提示"
  }
}

variable "environment" {
  type        = string
  description = "部署环境。"
  default     = "dev"

  # TODO 2：用 contains() 限制 environment 只能是 dev、stage、prod。
  # 提示：contains(["dev", "stage", "prod"], var.environment)
  validation {
    condition     = "TODO：限制 environment 在白名单内"
    error_message = "TODO：不合法环境的错误提示"
  }
}

resource "terraform_data" "validated_request" {
  input = {
    allowed_sizes = ["small", "medium", "large"]
    instance_size = var.instance_size
    environment   = var.environment
  }
}

output "validated_request" {
  value = terraform_data.validated_request.output
}
