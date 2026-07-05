run "advanced_for_expressions_are_correct" {
  command = plan

  assert {
    condition     = output.prod_application_names == ["checkout", "catalog"]
    error_message = "prod_application_names must keep only applications whose environment is prod."
  }

  assert {
    condition = output.enabled_applications == {
      checkout = {
        name        = "checkout"
        team        = "payments"
        environment = "prod"
        regions     = ["ap-southeast-2", "us-east-1"]
        enabled     = true
      }
      catalog = {
        name        = "catalog"
        team        = "commerce"
        environment = "prod"
        regions     = ["ap-southeast-1", "eu-west-1"]
        enabled     = true
      }
    }
    error_message = "enabled_applications must build a map of enabled applications keyed by name."
  }

  assert {
    condition = output.application_names_by_team == {
      commerce = ["catalog"]
      payments = ["checkout", "ledger"]
    }
    error_message = "application_names_by_team must group application names by team."
  }

  assert {
    condition = output.application_region_labels == [
      "checkout:ap-southeast-2",
      "checkout:us-east-1",
      "ledger:ap-southeast-2",
      "catalog:ap-southeast-1",
      "catalog:eu-west-1"
    ]
    error_message = "application_region_labels must flatten app and region pairs."
  }

  assert {
    condition = output.enabled_prod_primary_regions == {
      checkout = "ap-southeast-2"
      catalog  = "ap-southeast-1"
    }
    error_message = "enabled_prod_primary_regions must map enabled production apps to their first region."
  }

  assert {
    condition = output.application_environment_by_path == {
      "payments/checkout" = "prod"
      "payments/ledger"   = "dev"
      "commerce/catalog"  = "prod"
    }
    error_message = "application_environment_by_path must be keyed by team/name."
  }
}
