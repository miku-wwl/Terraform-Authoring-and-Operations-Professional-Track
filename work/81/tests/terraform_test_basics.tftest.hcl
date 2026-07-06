run "terraform_test_file_discovery_and_run_blocks_are_correct" {
  command = plan

  assert {
    condition     = length(output.candidate_files) == 6
    error_message = "candidate_files must decode all file records from data/terraform-test-workflow.json."
  }

  assert {
    condition = output.valid_test_file_names == [
      "demo.tftest.hcl",
      "security_group.tftest.hcl",
      "workflow.tftest.json"
    ]
    error_message = "valid_test_file_names must include only files Terraform test can discover."
  }

  assert {
    condition = output.ignored_test_file_names == [
      "demo.tf",
      "demo.tf.test.hcl",
      "network.tftest.hcl"
    ]
    error_message = "ignored_test_file_names must include files with bad extension or bad test directory."
  }

  assert {
    condition = output.plan_stage_run_names == [
      "security_group_can_plan",
      "function_outputs_are_correct"
    ]
    error_message = "plan_stage_run_names must include only run blocks whose command is plan."
  }

  assert {
    condition = output.apply_stage_run_names == [
      "security_group_can_apply",
      "resource_lifecycle_works"
    ]
    error_message = "apply_stage_run_names must include run blocks that represent apply behavior."
  }

  assert {
    condition = output.test_file_summary_by_name == {
      "demo.tftest.hcl" = {
        location   = "root"
        extension  = ".tftest.hcl"
        discovered = true
      }
      "security_group.tftest.hcl" = {
        location   = "tests"
        extension  = ".tftest.hcl"
        discovered = true
      }
      "workflow.tftest.json" = {
        location   = "tests"
        extension  = ".tftest.json"
        discovered = true
      }
      "demo.tf" = {
        location   = "root"
        extension  = ".tf"
        discovered = false
      }
      "demo.tf.test.hcl" = {
        location   = "root"
        extension  = ".tf.test.hcl"
        discovered = false
      }
      "network.tftest.hcl" = {
        location   = "test"
        extension  = ".tftest.hcl"
        discovered = false
      }
    }
    error_message = "test_file_summary_by_name must be keyed by file name and preserve location, extension, and discovered."
  }
}
