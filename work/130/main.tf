terraform {
  required_version = ">= 1.5.0"
}

locals {
  health_notes  = lower(file("${path.module}/hcp/health_assessments.md"))
  check_example = lower(file("${path.module}/examples/continuous_validation_check.tf"))
  alt_script    = lower(file("${path.module}/commands/health_assessment_alternatives.sh"))

  # HCP Terraform Health Assessments concept checks.
  health_assessments_summary_is_complete = strcontains(
    local.health_notes,
    "hcp terraform health assessments evaluate whether real infrastructure matches terraform configuration"
  )

  drift_detection_is_described = alltrue([
    strcontains(local.health_notes, "drift detection determines whether real infrastructure matches terraform configuration"),
    strcontains(local.health_notes, "manual changes can cause configuration drift")
  ])

  continuous_validation_is_described = strcontains(
    local.health_notes,
    "continuous validation checks whether custom conditions continue to pass after terraform provisions the resource"
  )

  tier_limitation_is_documented = alltrue([
    strcontains(local.health_notes, "standard and premium"),
    strcontains(local.health_notes, "not available in essentials")
  ])

  # Static Terraform check block example checks.
  check_block_example_is_present = alltrue([
    strcontains(local.check_example, "data "http" "website""),
    strcontains(local.check_example, "check "website_health""),
    strcontains(local.check_example, "data.http.website.status_code == 200"),
    strcontains(local.check_example, "unhealthy status code")
  ])

  # Custom alternative workflow checks.
  alternative_workflow_is_documented = alltrue([
    strcontains(local.alt_script, "terraform plan -detailed-exitcode"),
    strcontains(local.alt_script, "terraform test"),
    strcontains(local.alt_script, "cron"),
    strcontains(local.alt_script, "slack")
  ])

  health_assessment_types = {
    drift_detection      = "detect configuration drift between real infrastructure and Terraform configuration"
    continuous_validation = "check custom conditions after resources are provisioned"
  }
}

resource "terraform_data" "lesson" {
  input = {
    topic = "hcp terraform health assessments basics"
    types = local.health_assessment_types
  }
}

output "health_assessments_summary_is_complete" {
  description = "Whether the health assessment purpose is documented."
  value       = local.health_assessments_summary_is_complete
}

output "drift_detection_is_described" {
  description = "Whether drift detection and manual drift causes are documented."
  value       = local.drift_detection_is_described
}

output "continuous_validation_is_described" {
  description = "Whether continuous validation is documented."
  value       = local.continuous_validation_is_described
}

output "tier_limitation_is_documented" {
  description = "Whether Standard/Premium availability and Essentials limitation are documented."
  value       = local.tier_limitation_is_documented
}

output "check_block_example_is_present" {
  description = "Whether the continuous validation check block example is present."
  value       = local.check_block_example_is_present
}

output "alternative_workflow_is_documented" {
  description = "Whether self-managed drift/check automation alternatives are documented."
  value       = local.alternative_workflow_is_documented
}

output "health_assessment_types" {
  description = "Two HCP Terraform health assessment evaluation types."
  value       = local.health_assessment_types
}
