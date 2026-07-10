terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode data/debugging.json.
  # Hint: use jsondecode(file("${path.module}/data/debugging.json")).
  debugging = {}

  # TODO 2: Read the ordered log level list from the decoded object.
  log_levels = []

  # TODO 3: Select the highest-verbosity level from the ordered list.
  # Hint: use the final element of local.log_levels.
  highest_verbosity = ""

  # TODO 4: Build a map containing the temporary INFO command for each shell.
  # Expected keys: windows_cmd, powershell, linux_macos.
  # PowerShell values must wrap INFO in double quotes.
  temporary_log_commands = {}

  # TODO 5: Build a map where each shell has a two-element list:
  # [set TF_LOG to TRACE, set TF_LOG_PATH to the configured log file].
  # PowerShell values must wrap TRACE and the path in double quotes.
  trace_file_commands = {}

  # TODO 6: Build a map where each shell has a two-element list that clears
  # TF_LOG and TF_LOG_PATH for the current shell session.
  cleanup_commands = {}
}

resource "terraform_data" "debug_demo" {
  input = {
    topic             = "Terraform debugging environment variables"
    normal_plan_safe  = true
    cloud_credentials = false
  }
}

output "log_levels" {
  description = "Terraform log levels ordered from lower to higher verbosity."
  value       = local.log_levels
}

output "highest_verbosity" {
  description = "The most verbose Terraform log level."
  value       = local.highest_verbosity
}

output "temporary_log_commands" {
  description = "Session-scoped commands that enable INFO logging."
  value       = local.temporary_log_commands
}

output "trace_file_commands" {
  description = "Commands that enable TRACE logging and redirect it to a file."
  value       = local.trace_file_commands
}

output "cleanup_commands" {
  description = "Commands that remove Terraform debugging variables from the session."
  value       = local.cleanup_commands
}
