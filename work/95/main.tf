terraform {
  required_version = ">= 1.5.0"
}

locals {
  ec2_module_main = file("${path.module}/modules/ec2/main.tf")
  team_a_main     = file("${path.module}/teams/team_a/main.tf")

  # Child module checks.
  ec2_module_has_hardcoded_provider_block = can(regex("(?m)^\\s*provider\\s+\"aws\"\\s*\\{", local.ec2_module_main))
  ec2_module_has_region_variable          = can(regex("(?m)^\\s*variable\\s+\"region\"\\s*\\{", local.ec2_module_main))

  ec2_module_has_terraform_block       = can(regex("(?m)^\\s*terraform\\s*\\{", local.ec2_module_main))
  ec2_module_has_required_providers    = can(regex("required_providers\\s*\\{", local.ec2_module_main))
  ec2_module_declares_aws_provider_key = can(regex("aws\\s*=\\s*\\{", local.ec2_module_main))
  ec2_module_uses_hashicorp_aws_source = can(regex("source\\s*=\\s*\"hashicorp/aws\"", local.ec2_module_main))
  ec2_module_sets_aws_version          = can(regex("version\\s*=\\s*\">=\\s*5\\.5\"", local.ec2_module_main))

  ec2_module_required_provider_ready = alltrue([
    local.ec2_module_has_terraform_block,
    local.ec2_module_has_required_providers,
    local.ec2_module_declares_aws_provider_key,
    local.ec2_module_uses_hashicorp_aws_source,
    local.ec2_module_sets_aws_version
  ])

  # Caller checks.
  team_a_has_provider_block          = can(regex("(?m)^\\s*provider\\s+\"aws\"\\s*\\{", local.team_a_main))
  team_a_provider_uses_region_var    = can(regex("(?m)^\\s*region\\s*=\\s*var\\.aws_region", local.team_a_main))
  team_a_calls_ec2_module            = can(regex("(?m)^\\s*module\\s+\"ec2\"\\s*\\{", local.team_a_main))
  team_a_module_uses_local_ec2_source = can(regex("source\\s*=\\s*\"\\.\\./\\.\\./modules/ec2\"", local.team_a_main))

  # The starter module call passes a literal region argument. After the fix,
  # provider region should be handled by teams/team_a provider block instead.
  team_a_module_region_argument_removed = !can(regex("(?m)^\\s*region\\s*=\\s*\"ap-south-1\"", local.team_a_main))

  team_a_provider_ready = alltrue([
    local.team_a_has_provider_block,
    local.team_a_provider_uses_region_var,
    local.team_a_calls_ec2_module,
    local.team_a_module_uses_local_ec2_source
  ])

  provider_improvement_summary = {
    child_module_provider_block_removed = !local.ec2_module_has_hardcoded_provider_block
    child_module_region_variable_removed = !local.ec2_module_has_region_variable
    child_module_required_provider_ready = local.ec2_module_required_provider_ready
    caller_provider_ready               = local.team_a_provider_ready
    caller_module_region_argument_removed = local.team_a_module_region_argument_removed
  }
}

resource "terraform_data" "lesson" {
  input = {
    topic   = "custom module provider improvements"
    summary = local.provider_improvement_summary
  }
}

output "ec2_module_has_hardcoded_provider_block" {
  description = "Whether modules/ec2/main.tf still contains provider \"aws\". This should be false after the fix."
  value       = local.ec2_module_has_hardcoded_provider_block
}

output "ec2_module_region_variable_removed" {
  description = "Whether variable \"region\" has been removed from the child EC2 module."
  value       = !local.ec2_module_has_region_variable
}

output "ec2_module_required_provider_ready" {
  description = "Whether modules/ec2/main.tf declares required_providers.aws with hashicorp/aws and >= 5.5."
  value       = local.ec2_module_required_provider_ready
}

output "team_a_provider_ready" {
  description = "Whether teams/team_a/main.tf configures provider \"aws\" with region = var.aws_region and calls the EC2 module."
  value       = local.team_a_provider_ready
}

output "team_a_module_region_argument_removed" {
  description = "Whether the old literal region argument has been removed from module \"ec2\" in teams/team_a/main.tf."
  value       = local.team_a_module_region_argument_removed
}

output "provider_improvement_summary" {
  description = "Summary of the provider improvement checks."
  value       = local.provider_improvement_summary
}
