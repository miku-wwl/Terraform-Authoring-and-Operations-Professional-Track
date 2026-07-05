# TODO 1: Keep this provider block at the root of the test file.
# This demonstrates that a .tftest.hcl file can declare provider configuration.
provider "local" {}

variables {
  # TODO 2: Change this value to "test-firewall".
  firewall_name = "demo-firewall"

  # TODO 3: Change this value to "test".
  environment = "prod"

  # TODO 4: Change this value to "ap-south-1".
  region_label = "us-east-1"
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
