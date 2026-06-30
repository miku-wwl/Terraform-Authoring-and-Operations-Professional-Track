terraform {
  required_version = ">= 1.5.0"
}

locals {
  resource_behaviors = [
    "配置中存在但 state 中不存在的对象会被创建",
    "state 中存在但配置中不存在的对象会被销毁",
    "可变属性变化时通常会原地更新",

  ]

  meta_arguments = ["depends_on", "count", "for_each", "provider", "TODO-lifecycle"]
}

resource "terraform_data" "resource_model" {
  input = {
    behaviors      = local.resource_behaviors
    meta_arguments = local.meta_arguments
  }
}

output "resource_model" {
  value = terraform_data.resource_model.output
}
