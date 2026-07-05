terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the debugging mock file.
  # Hint: use jsondecode(file("${path.module}/data/debugging.json")).
  debug_config = {}

  # TODO 2: Read the log_levels list from the decoded JSON object.
  # Hint: use local.debug_config.log_levels.
  log_levels = []

  # TODO 3: Build a list of supported log level names.
  # Hint: use [for level in local.log_levels : level.name].
  supported_log_levels = []

  # TODO 4: Find the most verbose log level by the smallest verbosity_rank.
  # Hint: sort by rank with a formatted prefix, then split the first item.
  # Example idea: split(":", sort([for level in local.log_levels : format("%02d:%s", level.verbosity_rank, level.name)])[0])[1]
  most_verbose_log_level = ""

  # TODO 5: Build the Bash command that enables TF_LOG and TF_LOG_PATH for terraform plan.
  # Expected shape: TF_LOG=TRACE TF_LOG_PATH=terraform-debug.log terraform plan -input=false -no-color
  debug_command_bash = ""

  # TODO 6: Build the PowerShell command that enables TF_LOG and TF_LOG_PATH for terraform plan.
  # Expected shape: $env:TF_LOG="TRACE"; $env:TF_LOG_PATH="terraform-debug.log"; terraform plan -input=false -no-color
  debug_command_powershell = ""

  # TODO 7: Build a map of debugging checklist questions keyed by id.
  # Hint: use { for item in local.debug_config.checklist : item.id => item.question }.
  debugging_checklist = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic                  = "terraform debugging with TF_LOG and TF_LOG_PATH"
    supported_log_levels   = local.supported_log_levels
    most_verbose_log_level = local.most_verbose_log_level
  }
}

output "supported_log_levels" {
  description = "Terraform log levels available for TF_LOG."
  value       = local.supported_log_levels
}

output "most_verbose_log_level" {
  description = "The most detailed Terraform log level from the mock data."
  value       = local.most_verbose_log_level
}

output "debug_command_bash" {
  description = "Bash command that sends verbose Terraform logs to a file."
  value       = local.debug_command_bash
}

output "debug_command_powershell" {
  description = "PowerShell command that sends verbose Terraform logs to a file."
  value       = local.debug_command_powershell
}

output "debugging_checklist" {
  description = "Debugging checklist built from the mock data."
  value       = local.debugging_checklist
}
