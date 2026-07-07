run "internal_module_base_structure_is_correct" {
  command = plan

  assert {
    condition     = output.root_folders == ["modules", "teams"]
    error_message = "root_folders must include the modules and teams top-level folders from the JSON file."
  }

  assert {
    condition     = output.module_names == ["ec2", "security-group"]
    error_message = "module_names must be built from the modules list."
  }

  assert {
    condition     = output.team_names == ["team-a", "team-b"]
    error_message = "team_names must be built from the teams list."
  }

  assert {
    condition = output.module_paths == [
      "modules/ec2",
      "modules/security-group"
    ]
    error_message = "module_paths must use the path field from each module record."
  }

  assert {
    condition = output.team_paths == [
      "teams/team-a",
      "teams/team-b"
    ]
    error_message = "team_paths must use the path field from each team record."
  }

  assert {
    condition = output.team_source_by_team == {
      "team-a" = "../../modules/ec2"
      "team-b" = "../../modules/security-group"
    }
    error_message = "team_source_by_team must map each team to its planned internal module source path."
  }

  assert {
    condition = output.planned_modules_by_team == {
      "team-a" = ["ec2"]
      "team-b" = ["security-group"]
    }
    error_message = "planned_modules_by_team must map each team to the module names it plans to reference."
  }

  assert {
    condition = output.internal_module_policy == {
      prefer_internal_modules = true
      reason                  = "niche requirements and controlled maintenance timeline"
    }
    error_message = "internal_module_policy must preserve the organization policy from the JSON file."
  }

  assert {
    condition = output.base_structure_paths == [
      "modules",
      "teams",
      "modules/ec2",
      "modules/security-group",
      "teams/team-a",
      "teams/team-b"
    ]
    error_message = "base_structure_paths must concatenate root folders, module paths, and team paths."
  }
}
