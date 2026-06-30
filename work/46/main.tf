terraform {
  required_version = ">= 1.5.0"
}

locals {
  lifecycle_arguments = {
    create_before_destroy = "先创建替代对象，再销毁旧对象"
    prevent_destroy       = "TODO：补充 prevent_destroy 的含义"
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
