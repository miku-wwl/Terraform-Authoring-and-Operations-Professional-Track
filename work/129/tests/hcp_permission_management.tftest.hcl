run "hcp_permission_management_is_modeled" {
  command = plan

  assert {
    condition     = output.organization_name == "example-kplabs-org"
    error_message = "organization_name must be read from data/permissions.json."
  }

  assert {
    condition     = output.team_count == 3
    error_message = "team_count must count all teams from the decoded JSON data."
  }

  assert {
    condition     = output.owner_team_names == ["owners"]
    error_message = "owner_team_names must include only teams where full_organization_access is true."
  }

  assert {
    condition     = output.safe_invite_team_names == ["developers", "security"]
    error_message = "safe_invite_team_names must exclude owners and preserve JSON order."
  }

  assert {
    condition     = output.selected_workspace_name == "dev-web-app"
    error_message = "selected_workspace_name must come from the dev-web-app workspace."
  }

  assert {
    condition     = output.developer_workspace_access_level == "custom"
    error_message = "developers must use the custom workspace access level on dev-web-app."
  }

  assert {
    condition = output.developer_permission_labels == [
      "run:read",
      "run:plan",
      "run:apply",
      "variables:write",
      "state:outputs-only",
      "sentinel_mocks:none",
      "run_tasks:read"
    ]
    error_message = "developer_permission_labels must summarize developers custom workspace permissions."
  }

  assert {
    condition     = output.security_workspace_state_access == "read"
    error_message = "security_workspace_state_access must be read from the security workspace access entry."
  }

  assert {
    condition     = output.owner_private_registry_permission == "manage"
    error_message = "owner_private_registry_permission must come from the owners team entry."
  }

  assert {
    condition = output.invite_team_assignments == {
      "new.dev@example.com" = "developers"
      "new.sec@example.com" = "security"
    }
    error_message = "invite_team_assignments must map pending invitation email addresses to team names."
  }
}
