run "debugging_env_vars_are_documented" {
  command = apply

  assert {
    condition     = contains(output.debug_env_vars, "TF_LOG") && contains(output.debug_env_vars, "TF_LOG_PATH")
    error_message = "必须记录 TF_LOG 和 TF_LOG_PATH。"
  }

  assert {
    condition     = output.debug_step_count == 5
    error_message = "必须记录五步调试流程。"
  }
}
