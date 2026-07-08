run "module_variables_allow_each_caller_to_override_values" {
  command = plan

  assert {
    condition     = output.team_one_profile.name == "team-one-api"
    error_message = "team_one_profile.name must come from var.name passed by the team_one module call."
  }

  assert {
    condition     = output.team_one_profile.environment == "dev"
    error_message = "team_one_profile.environment must come from var.environment."
  }

  assert {
    condition     = output.team_one_profile.instance_type == "t2.micro"
    error_message = "team_one_profile.instance_type must come from var.instance_type."
  }

  assert {
    condition     = output.team_one_profile.enable_hibernation == false
    error_message = "team_one_profile.enable_hibernation must come from var.enable_hibernation."
  }

  assert {
    condition = output.team_one_profile.tags == tomap({
      team        = "platform"
      cost_center = "cc-100"
    })
    error_message = "team_one_profile.tags must come from var.tags."
  }

  assert {
    condition     = output.team_two_profile.name == "team-two-worker"
    error_message = "team_two_profile.name must come from var.name passed by the team_two module call."
  }

  assert {
    condition     = output.team_two_profile.environment == "prod"
    error_message = "team_two_profile.environment must come from var.environment."
  }

  assert {
    condition     = output.team_two_profile.instance_type == "m5.large"
    error_message = "team_two_profile.instance_type must come from var.instance_type, not a hardcoded default."
  }

  assert {
    condition     = output.team_two_profile.enable_hibernation == true
    error_message = "team_two_profile.enable_hibernation must come from var.enable_hibernation."
  }

  assert {
    condition = output.team_two_profile.tags == tomap({
      team        = "payments"
      cost_center = "cc-200"
    })
    error_message = "team_two_profile.tags must come from var.tags."
  }

  assert {
    condition = output.instance_types_by_team == {
      team_one = "t2.micro"
      team_two = "m5.large"
    }
    error_message = "The same module must support different instance_type values from different callers."
  }

  assert {
    condition = output.module_labels == [
      "team-one-api:dev:t2.micro",
      "team-two-worker:prod:m5.large"
    ]
    error_message = "module_labels must be built from variable-backed selected values."
  }
}
