run "resource_behavior_meta_arguments_are_modelled" {
  command = apply

  assert {
    condition     = contains(output.resource_behavior_model.created_services, "api")
    error_message = "必须用 for_each 创建 api 服务对象。"
  }

  assert {
    condition     = lookup(output.resource_behavior_model.service_versions, "api", "") == "1.0.0"
    error_message = "service_version 应作为可原地更新的 input 字段。"
  }

  assert {
    condition     = lookup(output.resource_behavior_model.replacement_generations, "api", "") == "generation-1"
    error_message = "deployment_generation 应作为替换触发信号。"
  }

  assert {
    condition     = lookup(output.resource_behavior_model.replacement_triggers, "api", "") == "generation-1"
    error_message = "triggers_replace 应引用 replacement_generation。"
  }

  assert {
    condition     = lookup(output.resource_behavior_model.replacement_orders, "api", "") == "create_before_destroy"
    error_message = "替换策略应记录为 create_before_destroy。"
  }

  assert {
    condition     = contains(output.resource_behavior_model.meta_arguments, "for_each") && contains(output.resource_behavior_model.meta_arguments, "lifecycle")
    error_message = "实验必须覆盖 for_each 和 lifecycle meta-argument。"
  }
}
