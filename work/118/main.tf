terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform pricing mock file.
  # Hint: use jsondecode(file("${path.module}/data/pricing.json")).
  pricing = {}

  # TODO 2: Read the plans list from the decoded JSON object.
  # Hint: use local.pricing.plans.
  plans = []

  # TODO 3: Build a list of all plan names.
  # Hint: use [for plan in local.plans : plan.name].
  plan_names = []

  # TODO 4: Build a map of plans keyed by plan name.
  # Hint: use { for plan in local.plans : plan.name => plan }.
  plans_by_name = {}

  # TODO 5: Find plan names that do not include audit_logging.
  # Hint: use contains(plan.features, "audit_logging") with a negated if condition.
  plans_without_audit_logging = []

  # TODO 6: Find plan names that include air_gapped_installation.
  # Hint: use contains(plan.features, "air_gapped_installation").
  air_gapped_plan_names = []

  # TODO 7: Read billing model names from local.pricing.billing_models.
  # Hint: use a for expression over local.pricing.billing_models.
  billing_model_names = []

  # TODO 8: Build an exam summary object from the values above.
  # Required keys: entry_plan, highest_hcp_managed_plan, has_pay_as_you_go, air_gapped_is_enterprise_only.
  # Hint: entry_plan should be the first plan name; highest HCP managed plan is Premium in this mock dataset.
  exam_summary = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "hcp terraform pricing plans"
    product      = try(local.pricing.product, "unknown")
    plan_count   = length(local.plans)
    billing_mode = local.billing_model_names
  }
}

output "plan_names" {
  description = "All pricing plan names in the mock dataset."
  value       = local.plan_names
}

output "plans_by_name" {
  description = "Pricing plans keyed by plan name."
  value       = local.plans_by_name
}

output "plans_without_audit_logging" {
  description = "Plans that do not include audit_logging in this mock dataset."
  value       = local.plans_without_audit_logging
}

output "air_gapped_plan_names" {
  description = "Plans that include air_gapped_installation in this mock dataset."
  value       = local.air_gapped_plan_names
}

output "billing_model_names" {
  description = "Billing model names from the mock dataset."
  value       = local.billing_model_names
}

output "exam_summary" {
  description = "Small summary of the pricing concepts emphasized by this lab."
  value       = local.exam_summary
}
