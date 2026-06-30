run "tf_log_env_is_documented" {
  command = apply

  assert {
    condition     = output.tf_log == "TRACE"
    error_message = "必须记录 TF_LOG=TRACE。"
  }

  assert {
    condition     = output.tf_log_path == "logs/terraform-debug.log"
    error_message = "必须记录 TF_LOG_PATH。"
  }
}
