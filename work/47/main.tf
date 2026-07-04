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
    service       = "checkout"
    image_version = var.image_version
  }

  triggers_replace = var.image_version

  lifecycle {
    create_before_destroy = true
  }
}

output "release_id" {
  description = "当前 release 对象的 id；替换发生时这个 id 会变化。"
  value       = terraform_data.service_release.id
}

output "release_image_version" {
  description = "当前 release 记录的镜像版本。"
  value       = terraform_data.service_release.input.image_version
}
