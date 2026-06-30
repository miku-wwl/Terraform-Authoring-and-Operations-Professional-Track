run "lifecycle_arguments_are_documented" {
  command = apply

  assert {
    condition     = length(keys(output.lifecycle_arguments)) == 4
    error_message = "必须记录四个常见 lifecycle 参数。"
  }

  assert {
    condition     = strcontains(output.lifecycle_arguments.prevent_destroy, "阻止")
    error_message = "prevent_destroy 的说明必须准确。"
  }
}
