terraform {
  required_version = ">= 1.5.0"
}

locals {
  lifecycle_arguments = {
    create_before_destroy = "先创建替代对象，再销毁旧对象"
    prevent_destroy       = "阻止 Terraform 销毁受保护资源"
    ignore_changes        = "忽略指定属性的外部漂移"
    replace_triggered_by  = "引用对象变化时触发替换"
  }
}

resource "terraform_data" "lifecycle_overview" {
  input = local.lifecycle_arguments
}

output "lifecycle_arguments" {
  value = terraform_data.lifecycle_overview.output
}
