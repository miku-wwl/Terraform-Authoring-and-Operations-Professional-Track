run "hcp_cli_driven_workflow_is_configured" {
  command = plan

  assert {
    condition     = output.cloud_block_is_present == true
    error_message = "hcp/cli_workflow.tf must include a terraform cloud block."
  }

  assert {
    condition     = output.organization_is_configured == true
    error_message = "Set cloud organization to my-kplabs-org."
  }

  assert {
    condition     = output.workspace_is_configured == true
    error_message = "Set cloud workspace name to remote-operation-workspace."
  }

  assert {
    condition     = output.aws_provider_is_declared == true
    error_message = "Keep the provider \"aws\" block in hcp/cli_workflow.tf."
  }

  assert {
    condition     = output.aws_region_is_configured == true
    error_message = "Set provider region to us-east-1."
  }

  assert {
    condition     = output.security_group_is_declared == true
    error_message = "Keep the resource address aws_security_group.allow_tls."
  }

  assert {
    condition     = output.security_group_is_named_allow_tls == true
    error_message = "Set the security group name to allow_tls."
  }

  assert {
    condition     = output.cli_commands_are_ready == true
    error_message = "commands/cli_driven_workflow.sh must include terraform init -input=false, terraform plan, terraform apply -auto-approve, and terraform destroy -auto-approve."
  }
}
