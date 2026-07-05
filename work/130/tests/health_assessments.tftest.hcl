run "hcp_terraform_health_assessments_are_documented" {
  command = plan

  assert {
    condition     = output.health_assessments_summary_is_complete == true
    error_message = "Document that HCP Terraform health assessments evaluate whether real infrastructure matches Terraform configuration."
  }

  assert {
    condition     = output.drift_detection_is_described == true
    error_message = "Document drift detection and mention that manual changes can cause configuration drift."
  }

  assert {
    condition     = output.continuous_validation_is_described == true
    error_message = "Document that continuous validation checks custom conditions after Terraform provisions the resource."
  }

  assert {
    condition     = output.tier_limitation_is_documented == true
    error_message = "Document that health assessments are available in Standard and Premium tiers and are not available in Essentials."
  }

  assert {
    condition     = output.check_block_example_is_present == true
    error_message = "examples/continuous_validation_check.tf must include data "http" "website", check "website_health", status_code == 200, and an unhealthy status code message."
  }

  assert {
    condition     = output.alternative_workflow_is_documented == true
    error_message = "commands/health_assessment_alternatives.sh must include terraform plan -detailed-exitcode, terraform test, cron, and Slack."
  }
}
