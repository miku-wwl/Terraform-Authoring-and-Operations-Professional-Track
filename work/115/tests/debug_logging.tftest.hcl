run "real_debug_logs_were_generated" {
  command = plan

  assert {
    condition = output.debug_target == {
      lesson = "TF_LOG and TF_LOG_PATH"
      goal   = "compare INFO and TRACE logs"
    }
    error_message = "The debug target must remain available for repeatable plan logging."
  }

  assert {
    condition     = fileexists("${path.module}/terraform-info.log")
    error_message = "terraform-info.log is missing. Follow TODO 2 in main.tf with TF_LOG=INFO and TF_LOG_PATH set."
  }

  assert {
    condition     = fileexists("${path.module}/terraform-trace.log")
    error_message = "terraform-trace.log is missing. Follow TODO 3 in main.tf with TF_LOG=TRACE and TF_LOG_PATH set."
  }

  assert {
    condition     = strcontains(try(file("${path.module}/terraform-info.log"), ""), "[INFO]")
    error_message = "terraform-info.log must contain real INFO log entries."
  }

  assert {
    condition     = strcontains(try(file("${path.module}/terraform-trace.log"), ""), "[TRACE]")
    error_message = "terraform-trace.log must contain real TRACE log entries."
  }

  assert {
    condition = length(try(file("${path.module}/terraform-trace.log"), "")) > length(
      try(file("${path.module}/terraform-info.log"), "")
    )
    error_message = "TRACE output should be more detailed than INFO output. Delete old logs and repeat TODO 2 and TODO 3."
  }
}
