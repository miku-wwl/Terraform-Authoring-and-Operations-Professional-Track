run "checkout_workspace_inherits_and_overrides_variables" {
  command = plan

  assert {
    condition = output.selected_workspace == {
      name    = "checkout-api"
      project = "commerce"
    }
    error_message = "The default selected workspace must be checkout-api in the commerce project."
  }

  assert {
    condition = output.applicable_variable_set_names == [
      "global-aws",
      "commerce-database",
      "checkout-features"
    ]
    error_message = "checkout-api must inherit global, commerce project, and checkout workspace Variable Sets."
  }

  assert {
    condition = output.effective_variable_values == {
      AWS_ACCESS_KEY_ID = "shared-access-key"
      AWS_REGION        = "ap-southeast-2"
      APP_LOG_LEVEL     = "debug"
      db_server         = "10.20.0.15"
      db_write_capacity = 15
      feature_mode      = "canary"
      service_owner     = "payments"
    }
    error_message = "Effective values must combine applicable Variable Sets and workspace overrides."
  }

  assert {
    condition = output.effective_variable_sources == {
      AWS_ACCESS_KEY_ID = "global-aws"
      AWS_REGION        = "global-aws"
      APP_LOG_LEVEL     = "workspace"
      db_server         = "commerce-database"
      db_write_capacity = "workspace"
      feature_mode      = "checkout-features"
      service_owner     = "workspace"
    }
    error_message = "Effective variable sources must identify inherited and workspace-supplied values."
  }

  assert {
    condition     = output.overridden_keys == ["APP_LOG_LEVEL", "db_write_capacity"]
    error_message = "Workspace variables must override APP_LOG_LEVEL and db_write_capacity."
  }

  assert {
    condition = output.terraform_variable_values == {
      db_server         = "10.20.0.15"
      db_write_capacity = 15
      feature_mode      = "canary"
      service_owner     = "payments"
    }
    error_message = "Terraform-category variables must be separated from environment variables."
  }

  assert {
    condition = output.environment_variable_values == {
      AWS_ACCESS_KEY_ID = "shared-access-key"
      AWS_REGION        = "ap-southeast-2"
      APP_LOG_LEVEL     = "debug"
    }
    error_message = "Environment-category variables must include the effective overridden values."
  }

  assert {
    condition     = output.sensitive_keys == ["AWS_ACCESS_KEY_ID"]
    error_message = "AWS_ACCESS_KEY_ID must be recognized as the sensitive effective variable."
  }
}

run "analytics_only_inherits_global_scope" {
  command = plan

  variables {
    workspace_name = "analytics"
  }

  assert {
    condition = output.selected_workspace == {
      name    = "analytics"
      project = "data"
    }
    error_message = "The second run must select the analytics workspace."
  }

  assert {
    condition     = output.applicable_variable_set_names == ["global-aws"]
    error_message = "analytics must inherit only the global Variable Set."
  }

  assert {
    condition = output.effective_variable_values == {
      AWS_ACCESS_KEY_ID   = "shared-access-key"
      AWS_REGION          = "us-west-2"
      DATA_RETENTION_DAYS = 30
    }
    error_message = "analytics must combine global variables with its own workspace variables."
  }

  assert {
    condition     = output.overridden_keys == ["AWS_REGION"]
    error_message = "The analytics workspace must override only AWS_REGION."
  }

  assert {
    condition = output.environment_variable_values == {
      AWS_ACCESS_KEY_ID = "shared-access-key"
      AWS_REGION        = "us-west-2"
    }
    error_message = "analytics environment variables must contain the workspace AWS_REGION override."
  }

  assert {
    condition = output.terraform_variable_values == {
      DATA_RETENTION_DAYS = 30
    }
    error_message = "analytics must expose DATA_RETENTION_DAYS as a Terraform variable."
  }
}
