terraform {
  required_version = ">= 1.5.0"
}

variable "instance_size" {
  type        = string
  description = "本地模拟的实例规格。"
  default     = "small"

  validation {
    condition     = contains(["small", "medium", "large"], var.instance_size)
    error_message = "instance_size 只能是 small、medium、large。"
  }
}

variable "environment" {
  type        = string
  description = "部署环境。"
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment 只能是 dev、stage、prod。"
  }
}

locals {
  # TODO 1：将 policy 中的 environment 从硬编码 "stage" 改为引用 var.environment。
  # 提示：policy 应使用变量值而非硬编码，使验证结果反映实际输入。
  policy = {
    allowed_sizes = ["small", "medium", "large"]
    environment   = "stage"
    instance_size = var.instance_size
  }
}

resource "terraform_data" "validated_request" {
  input = local.policy
}

output "validated_request" {
  value = terraform_data.validated_request.output
}
