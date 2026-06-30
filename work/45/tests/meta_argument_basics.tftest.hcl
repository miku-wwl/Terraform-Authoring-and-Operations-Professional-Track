run "resource_behavior_is_documented" {
  command = apply

  assert {
    condition     = length(output.resource_model.behaviors) == 4
    error_message = "必须记录 Terraform 的四类资源行为。"
  }

  assert {
    condition     = contains(output.resource_model.meta_arguments, "lifecycle")
    error_message = "必须记录 lifecycle meta-argument。"
  }
}
