run "sentinel_policy_set_model_is_correct" {
  command = plan

  assert {
    condition     = output.feature_name == "Sentinel"
    error_message = "feature_name must be read from data/sentinel_policy.json and equal Sentinel."
  }

  assert {
    condition     = output.requires_paid_plan == true
    error_message = "requires_paid_plan must be read from availability.requires_paid_plan and be true."
  }

  assert {
    condition     = output.workspace_name == "sentinel"
    error_message = "workspace_name must be read from workspace.name and equal sentinel."
  }

  assert {
    condition = output.policy_set == {
      name       = "sentinel-policy-set"
      scope      = "selected_workspaces"
      workspaces = ["sentinel"]
    }
    error_message = "policy_set must model the selected workspace policy set correctly."
  }

  assert {
    condition = output.policy == {
      name             = "check-ec2-tags"
      rule             = "block_ec2_without_tags"
      enforcement_mode = "hard-mandatory"
      required_tag_key = "Name"
    }
    error_message = "policy must model the EC2 tag Sentinel policy with hard-mandatory enforcement."
  }

  assert {
    condition = output.enforcement_modes == [
      "hard-mandatory",
      "soft-mandatory",
      "advisory"
    ]
    error_message = "enforcement_modes must include hard-mandatory, soft-mandatory, and advisory in order."
  }

  assert {
    condition = output.run_checks == [
      "cost_estimation",
      "policy_check"
    ]
    error_message = "run_checks must include cost_estimation followed by policy_check."
  }

  assert {
    condition = output.production_guardrail_layers == [
      "Terraform run policy check with Sentinel",
      "Cloud-side drift/resource compliance with AWS Config"
    ]
    error_message = "production_guardrail_layers must show Sentinel for Terraform runs and AWS Config for cloud-side compliance."
  }
}
