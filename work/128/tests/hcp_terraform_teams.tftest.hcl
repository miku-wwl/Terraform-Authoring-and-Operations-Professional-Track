run "hcp_terraform_teams_are_modeled_correctly" {
  command = plan

  assert {
    condition     = output.organization_name == "kp-labs"
    error_message = "organization_name must come from data/hcp-teams.json."
  }

  assert {
    condition     = output.organization_plan == "free"
    error_message = "organization_plan must read the free plan from the organization object."
  }

  assert {
    condition = output.team_names == [
      "owners",
      "platform-engineering",
      "app-developers"
    ]
    error_message = "team_names must return all team names in order."
  }

  assert {
    condition     = output.default_team_names == ["owners"]
    error_message = "default_team_names must return only the default owners team."
  }

  assert {
    condition     = output.owners_team.name == "owners" && output.owners_team.is_default == true
    error_message = "owners_team must select the owners team object from local.teams."
  }

  assert {
    condition     = output.owners_has_highest_access == true
    error_message = "owners_has_highest_access must confirm highest access plus manage_organization permission."
  }

  assert {
    condition = output.team_member_counts == {
      owners               = 32
      platform-engineering = 5
      app-developers       = 8
    }
    error_message = "team_member_counts must map each team name to its member_count."
  }

  assert {
    condition = output.pending_invitation_emails == [
      "bob@example.com",
      "carol@example.com"
    ]
    error_message = "pending_invitation_emails must select invitations where status is pending."
  }

  assert {
    condition = output.invitation_targets == [
      "alice@example.com -> owners",
      "bob@example.com -> platform-engineering",
      "carol@example.com -> app-developers"
    ]
    error_message = "invitation_targets must build email -> team labels for every invitation."
  }

  assert {
    condition = output.invitations_by_email["bob@example.com"].team == "platform-engineering" && output.invitations_by_email["carol@example.com"].status == "pending"
    error_message = "invitations_by_email must be keyed by invitation email."
  }
}
