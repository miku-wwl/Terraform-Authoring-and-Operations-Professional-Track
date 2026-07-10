terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode data/cli_workflow.json.
  # Hint: use jsondecode(file("${path.module}/data/cli_workflow.json")).
  workflow = {}

  # TODO 2: Build the HCP Terraform cloud target object.
  # Expected shape:
  # {
  #   hostname     = local.workflow.hostname
  #   organization = local.workflow.organization
  #   workspaces = {
  #     name = local.workflow.workspace.name
  #   }
  # }
  cloud_target = {}

  # TODO 3: Generate the ordered CLI command sequence from workflow.steps.
  # Hint: the JSON steps are already ordered; use a for expression.
  command_sequence = []

  # TODO 4: Build the browser URL for the linked workspace.
  # Expected format:
  # https://app.terraform.io/app/<organization>/workspaces/<workspace>
  workspace_url = ""

  # TODO 5: Detect evidence that the CLI-triggered run executes remotely.
  # It is remote only when execution_mode is "remote" AND the local and remote
  # Terraform versions are different.
  remote_execution_detected = false

  # TODO 6: Build authentication safety checks.
  # token_absent_from_mock should verify that authentication has no "token" key.
  # credentials_file_committed must reflect commit_credentials_file from JSON.
  authentication_safety = {
    token_absent_from_mock      = false
    credentials_file_committed = true
    credentials_file           = ""
  }

  # TODO 7: Build a final summary object from the completed locals.
  run_summary = {}
}

resource "terraform_data" "cli_driven_workflow" {
  input = {
    topic   = "HCP Terraform CLI-driven run workflow"
    summary = local.run_summary
  }
}

output "cloud_target" {
  description = "HCP Terraform hostname, organization, and workspace target."
  value       = local.cloud_target
}

output "command_sequence" {
  description = "CLI-driven workflow commands in execution order."
  value       = local.command_sequence
}

output "workspace_url" {
  description = "Browser URL for the linked HCP Terraform workspace."
  value       = local.workspace_url
}

output "remote_execution_detected" {
  description = "Whether the mock evidence indicates remote execution."
  value       = local.remote_execution_detected
}

output "authentication_safety" {
  description = "Checks related to token and credentials file handling."
  value       = local.authentication_safety
}

output "run_summary" {
  description = "Combined CLI-driven workflow summary."
  value       = local.run_summary
}
