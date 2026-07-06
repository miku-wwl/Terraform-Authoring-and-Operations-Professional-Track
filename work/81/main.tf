terraform {
  required_version = ">= 1.5.0"
}

locals {
  workflow = jsondecode(file("${path.module}/data/terraform-test-workflow.json"))

  candidate_files = local.workflow.candidate_files

  run_blocks = local.workflow.run_blocks

  valid_test_file_names = [for file in local.candidate_files : file.name if file.discovered]

  ignored_test_file_names = [for file in local.candidate_files : file.name if !file.discovered]

  plan_stage_run_names = [for run in local.run_blocks : run.name if run.command == "plan"]

  apply_stage_run_names = [for run in local.run_blocks : run.name if run.command == "apply"]

  test_file_summary_by_name = { for file in local.candidate_files : file.name => {
    location   = file.location
    extension  = file.extension
    discovered = file.discovered
  } }
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
