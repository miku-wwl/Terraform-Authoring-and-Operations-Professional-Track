run "real_session_debug_log_was_generated" {
  command = plan

  assert {
    condition = output.session_demo == {
      lesson = "temporary debug environment variables"
      shell  = "PowerShell"
    }
    error_message = "The session demo must remain available for repeatable logging plans."
  }

  assert {
    condition     = fileexists("${path.module}/terraform-debug.log")
    error_message = "terraform-debug.log is missing. Follow TODO 2 in main.tf with TF_LOG=TRACE and TF_LOG_PATH set."
  }

  assert {
    condition     = strcontains(try(file("${path.module}/terraform-debug.log"), ""), "[TRACE]")
    error_message = "terraform-debug.log must contain real TRACE entries."
  }
}
