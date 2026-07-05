terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the HCP Terraform signup mock file.
  # Hint: use jsondecode(file("${path.module}/data/hcp_signup.json")).
  hcp_signup = {}

  # TODO 2: Read the HCP Terraform portal URL from the decoded JSON object.
  # Hint: use local.hcp_signup.portal_url.
  portal_url = ""

  # TODO 3: Read the required account creation fields from the decoded JSON object.
  # Hint: use local.hcp_signup.account_creation.required_fields.
  account_fields = []

  # TODO 4: Configure a safe, non-real practice account identity.
  # Hint: username must be "lab119-user" and email must be "student+lab119@example.com".
  account_identity = {
    username = ""
    email    = ""
  }

  # TODO 5: Read whether email verification is required from the decoded JSON object.
  # Hint: use local.hcp_signup.account_creation.email_verification_required.
  email_verification_required = false

  # TODO 6: Configure the first organization and derive its slug.
  # Hint: organization_name must be "lab119-learning-org".
  # Hint: organization_slug can use lower(replace(local.organization_name, " ", "-")).
  organization_name = ""
  organization_slug = ""

  # TODO 7: Build the onboarding checklist in the required order.
  # Hint: interpolate local.portal_url and local.organization_name.
  onboarding_checklist = []
}

resource "terraform_data" "lesson" {
  input = {
    topic             = "hcp terraform account and organization bootstrap"
    portal_url        = local.portal_url
    organization_name = local.organization_name
  }
}

output "portal_url" {
  description = "HCP Terraform hosted service URL."
  value       = local.portal_url
}

output "account_fields" {
  description = "Fields required when creating the first HCP Terraform account."
  value       = local.account_fields
}

output "account_identity" {
  description = "Safe practice identity for this lab. Password must not be included."
  value       = local.account_identity
}

output "email_verification_required" {
  description = "Whether the account must be verified through email."
  value       = local.email_verification_required
}

output "organization_name" {
  description = "First HCP Terraform organization name for this lab."
  value       = local.organization_name
}

output "organization_slug" {
  description = "Normalized organization slug derived from organization_name."
  value       = local.organization_slug
}

output "onboarding_checklist" {
  description = "Ordered checklist for account and organization bootstrap."
  value       = local.onboarding_checklist
}
