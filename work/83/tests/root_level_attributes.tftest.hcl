# This demonstrates that a .tftest.hcl file can declare provider configuration.
provider "local" {}

variables {
  firewall_name = "test-firewall"

  environment = "test"

  region_label = "ap-south-1"
}

run "root_variables_override_main_defaults" {
  command = plan

  assert {
    condition     = output.firewall_name == "test-firewall"
    error_message = "The root-level variables block must override firewall_name to test-firewall."
  }

  assert {
    condition     = output.environment == "test"
    error_message = "The root-level variables block must override environment to test."
  }

  assert {
    condition     = output.region_label == "ap-south-1"
    error_message = "The root-level variables block must override region_label to ap-south-1."
  }
}

run "multiple_run_blocks_share_root_variables" {
  command = plan

  assert {
    condition     = output.resource_label == "test:ap-south-1:test-firewall"
    error_message = "Multiple run blocks should share the same root-level variables block values."
  }

  assert {
    condition     = endswith(output.marker_path, ".terraform-test-test-test-firewall.txt")
    error_message = "marker_path should be built from the test-level variable values."
  }
}
