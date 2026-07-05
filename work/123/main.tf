terraform {
  required_version = ">= 1.5.0"
}

locals {
  cli_workflow_tf = file("${path.module}/hcp/cli_workflow.tf")
  workflow_script = file("${path.module}/commands/cli_driven_workflow.sh")

  # HCP Terraform CLI-driven workflow checks.
  cloud_block_is_present      = can(regex("\\bcloud\\s*\\{", local.cli_workflow_tf))
  organization_is_configured  = can(regex("organization\\s*=\\s*\\\"my-kplabs-org\\\"", local.cli_workflow_tf))
  workspace_is_configured     = can(regex("workspaces\\s*\\{[\\s\\S]*name\\s*=\\s*\\\"remote-operation-workspace\\\"", local.cli_workflow_tf))
  aws_provider_is_declared    = can(regex("provider\\s+\\\"aws\\\"\\s*\\{", local.cli_workflow_tf))
  aws_region_is_configured    = can(regex("region\\s*=\\s*\\\"us-east-1\\\"", local.cli_workflow_tf))
  security_group_is_declared  = can(regex("resource\\s+\\\"aws_security_group\\\"\\s+\\\"allow_tls\\\"", local.cli_workflow_tf))
  security_group_is_named_allow_tls = can(regex("name\\s*=\\s*\\\"allow_tls\\\"", local.cli_workflow_tf))

  # Local CLI commands that start remote HCP Terraform runs.
  has_init_command    = can(regex("(?m)^\\s*terraform\\s+init\\s+-input=false\\s*$", local.workflow_script))
  has_plan_command    = can(regex("(?m)^\\s*terraform\\s+plan\\s*$", local.workflow_script))
  has_apply_command   = can(regex("(?m)^\\s*terraform\\s+apply\\s+-auto-approve\\s*$", local.workflow_script))
  has_destroy_command = can(regex("(?m)^\\s*terraform\\s+destroy\\s+-auto-approve\\s*$", local.workflow_script))

  cli_commands_are_ready = alltrue([
    local.has_init_command,
    local.has_plan_command,
    local.has_apply_command,
    local.has_destroy_command
  ])

  cli_driven_workflow_summary = {
    local_code_directory       = true
    remote_hcp_workspace_run   = true
    git_repository_required    = false
    workspace_credentials_need = "configure provider credentials as HCP Terraform workspace variables for real remote runs"
  }
}

resource "terraform_data" "lesson" {
  input = {
    topic   = "hcp terraform cli-driven workflow basics"
    summary = local.cli_driven_workflow_summary
  }
}

output "cloud_block_is_present" {
  description = "Whether hcp/cli_workflow.tf includes a cloud block."
  value       = local.cloud_block_is_present
}

output "organization_is_configured" {
  description = "Whether the HCP Terraform organization is configured."
  value       = local.organization_is_configured
}

output "workspace_is_configured" {
  description = "Whether the HCP Terraform workspace name is configured."
  value       = local.workspace_is_configured
}

output "aws_provider_is_declared" {
  description = "Whether the AWS provider block is present in the CLI workflow example."
  value       = local.aws_provider_is_declared
}

output "aws_region_is_configured" {
  description = "Whether the AWS provider region is configured as us-east-1."
  value       = local.aws_region_is_configured
}

output "security_group_is_declared" {
  description = "Whether aws_security_group.allow_tls is present in the CLI workflow example."
  value       = local.security_group_is_declared
}

output "security_group_is_named_allow_tls" {
  description = "Whether the demo security group name is allow_tls."
  value       = local.security_group_is_named_allow_tls
}

output "cli_commands_are_ready" {
  description = "Whether the local CLI commands for remote plan/apply/destroy are present."
  value       = local.cli_commands_are_ready
}

output "cli_driven_workflow_summary" {
  description = "Static summary of the HCP Terraform CLI-driven workflow."
  value       = local.cli_driven_workflow_summary
}
