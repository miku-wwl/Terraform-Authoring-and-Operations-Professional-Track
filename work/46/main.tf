terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：补全 prevent_destroy 的含义。
  # 提示：prevent_destroy 用于阻止 Terraform 意外销毁受保护的资源。
  # TODO 2：补充缺失的第四个 lifecycle 参数 replace_triggered_by 及其含义。
  # 提示：replace_triggered_by 在引用对象变化时触发本资源的替换。
  lifecycle_arguments = {
    create_before_destroy = "先创建替代对象，再销毁旧对象"
    prevent_destroy       = "TODO：补充 prevent_destroy 的含义"
    ignore_changes        = "忽略指定属性的外部漂移"
  }
}

resource "terraform_data" "lifecycle_overview" {
  input = local.lifecycle_arguments
}

output "lifecycle_arguments" {
  value = terraform_data.lifecycle_overview.output
}
