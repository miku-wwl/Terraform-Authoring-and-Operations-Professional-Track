run "terraform_debug_environment_commands_are_correct" {
  command = plan

  assert {
    condition = output.log_levels == [
      "ERROR",
      "WARN",
      "INFO",
      "DEBUG",
      "TRACE"
    ]
    error_message = "log_levels must be read from data/debugging.json in increasing verbosity order."
  }

  assert {
    condition     = output.highest_verbosity == "TRACE"
    error_message = "highest_verbosity must select TRACE from the final log level entry."
  }

  assert {
    condition = output.temporary_log_commands == {
      windows_cmd = "set TF_LOG=INFO"
      powershell  = "$env:TF_LOG = \"INFO\""
      linux_macos = "export TF_LOG=INFO"
    }
    error_message = "temporary_log_commands must use the correct syntax for CMD, PowerShell, and Linux/macOS."
  }

  assert {
    condition = output.trace_file_commands == {
      windows_cmd = [
        "set TF_LOG=TRACE",
        "set TF_LOG_PATH=terraform-debug.log"
      ]
      powershell = [
        "$env:TF_LOG = \"TRACE\"",
        "$env:TF_LOG_PATH = \"terraform-debug.log\""
      ]
      linux_macos = [
        "export TF_LOG=TRACE",
        "export TF_LOG_PATH=terraform-debug.log"
      ]
    }
    error_message = "trace_file_commands must enable TRACE and set TF_LOG_PATH for every supported shell."
  }

  assert {
    condition = output.cleanup_commands == {
      windows_cmd = [
        "set TF_LOG=",
        "set TF_LOG_PATH="
      ]
      powershell = [
        "Remove-Item Env:TF_LOG",
        "Remove-Item Env:TF_LOG_PATH"
      ]
      linux_macos = [
        "unset TF_LOG",
        "unset TF_LOG_PATH"
      ]
    }
    error_message = "cleanup_commands must clear both Terraform debug variables for every shell."
  }
}
