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

  # TODO 1: Make image_version changes replace this release object.
  # Hint: put var.image_version in triggers_replace. After apply, run:
  # terraform plan -var="image_version=v2" -input=false -no-color
  # The plan should show terraform_data.service_release must be replaced.
  triggers_replace = []

  lifecycle {
    # TODO 2: Change the replacement order to create the new object first.
    # Hint: set create_before_destroy to true. With TODO 1 also completed,
    # the replacement plan should say "create replacement and then destroy".
    create_before_destroy = false
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
