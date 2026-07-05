run "terraform_debug_logging_config_is_correct" {
  command = plan

  assert {
    condition = output.supported_log_levels == [
      "TRACE",
      "DEBUG",
      "INFO",
      "WARN",
      "ERROR"
    ]
    error_message = "supported_log_levels must contain all TF_LOG levels from data/debugging.json in decreasing verbosity order."
  }

  assert {
    condition     = output.most_verbose_log_level == "TRACE"
    error_message = "most_verbose_log_level must be calculated from the smallest verbosity_rank and should be TRACE."
  }

  assert {
    condition     = output.debug_command_bash == "TF_LOG=TRACE TF_LOG_PATH=terraform-debug.log terraform plan -input=false -no-color"
    error_message = "debug_command_bash must enable TF_LOG=TRACE, set TF_LOG_PATH, and run terraform plan."
  }

  assert {
    condition     = output.debug_command_powershell == "$env:TF_LOG=\"TRACE\"; $env:TF_LOG_PATH=\"terraform-debug.log\"; terraform plan -input=false -no-color"
    error_message = "debug_command_powershell must enable TF_LOG=TRACE, set TF_LOG_PATH, and run terraform plan."
  }

  assert {
    condition = output.debugging_checklist == {
      "root-cause" = "What is the root cause instead of only the surface error?"
      verbosity  = "Is TF_LOG set to a suitable level for the issue?"
      "log-file"   = "Is TF_LOG_PATH set so detailed logs are saved to a file?"
    }
    error_message = "debugging_checklist must be keyed by checklist id from data/debugging.json."
  }
}
