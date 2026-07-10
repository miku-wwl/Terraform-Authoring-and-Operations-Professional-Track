run "cli_driven_workflow_is_modelled_correctly" {
  command = plan

  assert {
    condition = output.cloud_target == {
      hostname     = "app.terraform.io"
      organization = "kplabs-terraform-learning"
      workspaces = {
        name = "cli-driven-workflow"
      }
    }
    error_message = "cloud_target must include the HCP hostname, organization, and workspace name."
  }

  assert {
    condition = output.command_sequence == [
      "terraform login app.terraform.io",
      "terraform init",
      "terraform plan",
      "terraform apply"
    ]
    error_message = "command_sequence must preserve login, init, plan, and apply order from the mock data."
  }

  assert {
    condition     = output.workspace_url == "https://app.terraform.io/app/kplabs-terraform-learning/workspaces/cli-driven-workflow"
    error_message = "workspace_url must point to the configured HCP Terraform workspace."
  }

  assert {
    condition     = output.remote_execution_detected
    error_message = "remote_execution_detected must require remote execution mode and different local/remote Terraform versions."
  }

  assert {
    condition = output.authentication_safety == {
      token_absent_from_mock      = true
      credentials_file_committed = false
      credentials_file           = "~/.terraform.d/credentials.tfrc.json"
    }
    error_message = "authentication_safety must confirm no token is stored in mock data and the credentials file is not committed."
  }

  assert {
    condition = output.run_summary == {
      organization              = "kplabs-terraform-learning"
      workspace                 = "cli-driven-workflow"
      execution_mode            = "remote"
      commands                  = output.command_sequence
      workspace_url             = output.workspace_url
      remote_execution_detected = true
      resource_type             = "time_sleep"
      wait_seconds              = 10
    }
    error_message = "run_summary must combine the workspace, execution mode, commands, URL, remote evidence, and mock resource details."
  }
}
