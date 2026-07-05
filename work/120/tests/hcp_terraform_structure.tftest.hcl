run "hcp_terraform_structure_is_modelled_correctly" {
  command = plan

  assert {
    condition     = output.organization_count == 2
    error_message = "organizations must decode the two organizations from data/hcp_platform.json."
  }

  assert {
    condition = output.billing_plan_by_org == {
      "kp-labs-org"     = "free"
      "xyz-company-org" = "standard"
    }
    error_message = "billing_plan_by_org must map each organization to its billing plan."
  }

  assert {
    condition = output.project_inventory == [
      {
        org_name            = "kp-labs-org"
        project_name        = "security-team-project"
        team_access_enabled = false
        workspace_count     = 3
      },
      {
        org_name            = "kp-labs-org"
        project_name        = "app-team-project"
        team_access_enabled = false
        workspace_count     = 2
      },
      {
        org_name            = "xyz-company-org"
        project_name        = "platform-project"
        team_access_enabled = true
        workspace_count     = 2
      }
    ]
    error_message = "project_inventory must flatten projects and preserve their organization context."
  }

  assert {
    condition     = output.workspace_count == 7
    error_message = "workspace_inventory must flatten all seven workspaces from the nested HCP model."
  }

  assert {
    condition = output.vcs_connected_workspace_names == [
      "aws-hardening",
      "azure-hardening",
      "gcp-hardening",
      "demo-workspace",
      "hcp-core",
      "network-foundation"
    ]
    error_message = "vcs_connected_workspace_names must exclude only the local scratch workspace with vcs_provider == none."
  }

  assert {
    condition = output.workspace_repository_map == {
      "aws-hardening"      = "kp-labs/aws-hardening"
      "azure-hardening"    = "KP-Labs/AzureHardening/_git/terraform"
      "gcp-hardening"      = "kp-labs/gcp-hardening"
      "demo-workspace"     = "kp-labs/demo-workspace"
      "hcp-core"           = "xyz-company/hcp-core"
      "network-foundation" = "xyz-company/network-foundation"
    }
    error_message = "workspace_repository_map must map only VCS-connected workspaces to their repositories."
  }

  assert {
    condition = output.sensitive_variables_by_workspace == {
      "aws-hardening"      = ["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY"]
      "azure-hardening"    = ["ARM_CLIENT_SECRET"]
      "gcp-hardening"      = ["GOOGLE_CREDENTIALS"]
      "demo-workspace"     = []
      "local-scratch"      = []
      "hcp-core"           = ["HCP_TOKEN"]
      "network-foundation" = ["AWS_SECRET_ACCESS_KEY"]
    }
    error_message = "sensitive_variables_by_workspace must preserve workspace-level sensitive variable names."
  }

  assert {
    condition     = output.standard_org_names == ["xyz-company-org"]
    error_message = "standard_org_names must identify organizations whose billing_plan is standard."
  }
}
