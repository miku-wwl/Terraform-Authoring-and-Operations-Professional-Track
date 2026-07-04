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
    precondition {
      condition     = contains(["small", "medium"], var.instance_size)
      error_message = "instance_size 只能是 small 或 medium"
    }

    postcondition {
      condition     = contains(["small", "medium"], self.output.size)
      error_message = "instance_size 只能是 small 或 medium"
    }
  }
}

output "compute_size" {
  value = terraform_data.compute_request.output.size
}
