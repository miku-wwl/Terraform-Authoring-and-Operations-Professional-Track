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

  lifecycle {
    create_before_destroy = true
  }
}

output "image_version" {
  value = terraform_data.service_release.output.image_version
}

output "replacement_strategy" {
  value = "create_before_destroy"
}
