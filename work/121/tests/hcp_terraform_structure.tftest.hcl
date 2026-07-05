run "hcp_terraform_structure_is_modeled_correctly" {
  command = plan

  assert {
    condition     = output.organization_name == "example-kplabs-org"
    error_message = "organization_name must be decoded from the organization object."
  }

  assert {
    condition     = length(output.projects) == 2
    error_message = "projects must decode all project objects from data/hcp-structure.json."
  }

  assert {
    condition     = output.user_created_project_names == ["Terraform Learning"]
    error_message = "user_created_project_names must keep only projects where auto_created is false."
  }

  assert {
    condition = output.workspace_workflows_by_name == {
      "learning-vcs-workspace" = "version_control"
      "learning-cli-workspace" = "cli_driven"
      "learning-api-workspace" = "api_driven"
    }
    error_message = "workspace_workflows_by_name must map each workspace name to its workflow."
  }

  assert {
    condition = output.workspace_project_pairs == [
      "learning-vcs-workspace->Terraform Learning",
      "learning-cli-workspace->Terraform Learning",
      "learning-api-workspace->Terraform Learning"
    ]
    error_message = "workspace_project_pairs must describe each workspace to project relationship."
  }

  assert {
    condition     = output.registry_feature_names == ["private_modules", "private_providers"]
    error_message = "registry_feature_names must include enabled private registry features."
  }

  assert {
    condition     = output.free_plan_summary == "free:500 resources"
    error_message = "free_plan_summary must combine organization plan and resource limit."
  }
}
