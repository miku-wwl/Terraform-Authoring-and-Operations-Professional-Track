run "custom_module_provider_improvements_are_applied" {
  command = plan

  assert {
    condition     = output.ec2_module_has_hardcoded_provider_block == false
    error_message = "Remove provider \"aws\" from modules/ec2/main.tf. The child module should not hardcode provider configuration."
  }

  assert {
    condition     = output.ec2_module_region_variable_removed == true
    error_message = "Remove variable \"region\" from modules/ec2/main.tf. Region should be configured by the caller provider block."
  }

  assert {
    condition     = output.ec2_module_required_provider_ready == true
    error_message = "Add terraform.required_providers.aws to modules/ec2/main.tf with source = \"hashicorp/aws\" and version = \">= 5.5\"."
  }

  assert {
    condition     = output.team_a_provider_ready == true
    error_message = "Configure provider \"aws\" in teams/team_a/main.tf with region = var.aws_region and keep the module source as ../../modules/ec2."
  }

  assert {
    condition     = output.team_a_module_region_argument_removed == true
    error_message = "Remove the literal region = \"ap-south-1\" argument from module \"ec2\" in teams/team_a/main.tf."
  }
}
