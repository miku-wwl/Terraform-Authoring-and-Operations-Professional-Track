terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the Terraform test workflow mock file.
  # Hint: use jsondecode(file("${path.module}/data/terraform-test-workflow.json")).
  workflow = {}

  # TODO 2: Read the candidate test files list from the decoded JSON object.
  # Hint: use local.workflow.candidate_files.
  candidate_files = []

  # TODO 3: Read the run block list from the decoded JSON object.
  # Hint: use local.workflow.run_blocks.
  run_blocks = []

  # TODO 4: Select names of test files that Terraform test will discover.
  # Hint: use a for expression with if file.discovered.
  valid_test_file_names = []

  # TODO 5: Select names of files that Terraform test will ignore.
  # Hint: use a for expression with if !file.discovered.
  ignored_test_file_names = []

  # TODO 6: Select run block names that explicitly run at plan stage.
  # Hint: use a for expression with if run.command == "plan".
  plan_stage_run_names = []

  # TODO 7: Select run block names that represent default apply behavior.
  # Hint: use a for expression with if run.command == "apply".
  apply_stage_run_names = []

  # TODO 8: Build a map of test file summaries keyed by file name.
  # Hint: use { for file in local.candidate_files : file.name => { ... } }.
  test_file_summary_by_name = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic      = "terraform test basics"
    test_files = local.candidate_files
    run_blocks = local.run_blocks
  }
}

output "candidate_files" {
  description = "Candidate files loaded from data/terraform-test-workflow.json."
  value       = local.candidate_files
}

output "valid_test_file_names" {
  description = "Test files discovered by terraform test."
  value       = local.valid_test_file_names
}

output "ignored_test_file_names" {
  description = "Files ignored because of extension or directory problems."
  value       = local.ignored_test_file_names
}

output "plan_stage_run_names" {
  description = "Run blocks using command = plan."
  value       = local.plan_stage_run_names
}

output "apply_stage_run_names" {
  description = "Run blocks representing apply behavior."
  value       = local.apply_stage_run_names
}

output "test_file_summary_by_name" {
  description = "Candidate test files summarized by file name."
  value       = local.test_file_summary_by_name
}
