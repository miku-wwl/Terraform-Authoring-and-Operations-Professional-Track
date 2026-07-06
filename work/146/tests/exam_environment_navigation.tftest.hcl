run "exam_environment_navigation_model_is_correct" {
  command = plan

  assert {
    condition     = output.exam_duration_minutes == 240
    error_message = "exam_duration_minutes must convert the 4 hour exam duration into 240 minutes."
  }

  assert {
    condition = output.stage_names == [
      "pre_exam_instructions",
      "pre_exam_survey",
      "multiple_choice_questions",
      "lab_scenarios",
      "post_exam_survey"
    ]
    error_message = "stage_names must preserve the ordered exam flow from the JSON data."
  }

  assert {
    condition     = output.lab_stage_names == ["lab_scenarios"]
    error_message = "lab_stage_names must select only stages where type is lab."
  }

  assert {
    condition = output.scenario_navigation_summary == {
      scenario_01 = {
        independent              = true
        has_architecture_diagram = true
        opens_vscode             = true
        opens_cli                = true
        has_validation_command   = true
        right_sidebar_items = [
          "cloud_console_username",
          "cloud_console_password",
          "access_key",
          "secret_key",
          "resource_links"
        ]
      }
      scenario_02 = {
        independent              = true
        has_architecture_diagram = false
        opens_vscode             = true
        opens_cli                = true
        has_validation_command   = true
        right_sidebar_items = [
          "access_key",
          "secret_key",
          "resource_links"
        ]
      }
      scenario_03 = {
        independent              = true
        has_architecture_diagram = true
        opens_vscode             = true
        opens_cli                = true
        has_validation_command   = true
        right_sidebar_items = [
          "resource_links"
        ]
      }
    }
    error_message = "scenario_navigation_summary must map each scenario id to VS Code, CLI, sidebar, and validation metadata."
  }

  assert {
    condition = output.allowed_resource_names == [
      "HashiCorp Terraform documentation",
      "Provider documentation"
    ]
    error_message = "allowed_resource_names must include only resources where allowed is true."
  }

  assert {
    condition = output.denied_resource_names == [
      "YouTube",
      "HashiCorp tutorials"
    ]
    error_message = "denied_resource_names must include only resources where allowed is false."
  }

  assert {
    condition = output.time_budget_minutes == {
      mcq    = 12
      lab    = 216
      review = 12
    }
    error_message = "time_budget_minutes must calculate 5/90/5 percent of 240 minutes."
  }
}
