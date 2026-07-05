terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the Terraform Professional booking mock file.
  # Hint: use jsondecode(file("${path.module}/data/terraform-professional-booking.json")).
  mock = {}

  # TODO 2: Read the portal object from the decoded JSON object.
  # Hint: use local.mock.portal.
  portal = {}

  # TODO 3: Read the exams list from the decoded JSON object.
  # Hint: use local.mock.exams.
  exams = []

  # TODO 4: Read the system compatibility check list.
  # Hint: use local.mock.system_compatibility_checks.
  system_compatibility_checks = []

  # TODO 5: Read the accommodations list.
  # Hint: use local.mock.accommodations.
  accommodations = []

  # TODO 6: Read the booking steps list.
  # Hint: use local.mock.booking_steps.
  booking_steps = []

  # TODO 7: Read the payment options list.
  # Hint: use local.mock.payment_options.
  payment_options = []

  # TODO 8: Read the exam day object.
  # Hint: use local.mock.exam_day.
  exam_day = {}

  # TODO 9: Select the single professional exam object.
  # Hint: use one([for exam in local.exams : exam if exam.level == "professional"]).
  professional_exam = {}

  # TODO 10: Return all booking step names in order.
  # Hint: use [for step in local.booking_steps : step.name].
  booking_step_names = []

  # TODO 11: Build a map of booking steps keyed by order as a string.
  # Hint: use { for step in local.booking_steps : tostring(step.order) => step }.
  booking_steps_by_order = {}

  # TODO 12: Return only accommodation names that add extra time.
  # Hint: use a for expression with if accommodation.extra_minutes > 0.
  extra_time_accommodation_names = []

  # TODO 13: Calculate the total professional exam duration with extra time.
  # Hint: base duration + the sum of extra_minutes from matching extra-time accommodations.
  professional_duration_with_extra_time_minutes = 0

  # TODO 14: Build a map of payment options keyed by payment option name.
  # Hint: use { for option in local.payment_options : option.name => option }.
  payment_options_by_name = {}

  # TODO 15: Check exam-day readiness.
  # Hint: require screenshot recommended, confirmation email required, and a 20 to 30 minute early-start window.
  exam_day_ready = false
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "terraform professional exam booking workflow"
    login        = try(local.portal.login_provider, "")
    professional = try(local.professional_exam.name, "")
  }
}

output "official_domain_suffix" {
  description = "Official HashiCorp domain suffix to verify before booking."
  value       = try(local.portal.official_domain_suffix, "")
}

output "login_provider" {
  description = "Identity provider used by the exam booking portal."
  value       = try(local.portal.login_provider, "")
}

output "candidate_name_must_match_government_id" {
  description = "Whether candidate name must match government ID."
  value       = try(local.portal.candidate_name_must_match_government_id, false)
}

output "professional_exam_name" {
  description = "Selected Terraform Professional exam name."
  value       = try(local.professional_exam.name, "")
}

output "professional_base_duration_minutes" {
  description = "Base duration of the Terraform Professional exam."
  value       = try(local.professional_exam.base_duration_minutes, 0)
}

output "professional_attempts_included" {
  description = "Number of attempts included for the professional exam in the mock data."
  value       = try(local.professional_exam.attempts_included, 0)
}

output "system_compatibility_checks" {
  description = "System compatibility checks to complete before scheduling."
  value       = local.system_compatibility_checks
}

output "extra_time_accommodation_names" {
  description = "Accommodation names that add extra time."
  value       = local.extra_time_accommodation_names
}

output "professional_duration_with_extra_time_minutes" {
  description = "Professional exam duration after extra time accommodation."
  value       = local.professional_duration_with_extra_time_minutes
}

output "booking_step_names" {
  description = "Booking workflow step names in order."
  value       = local.booking_step_names
}

output "booking_steps_by_order" {
  description = "Booking steps keyed by order string."
  value       = local.booking_steps_by_order
}

output "payment_options_by_name" {
  description = "Payment options keyed by option name."
  value       = local.payment_options_by_name
}

output "exam_day_ready" {
  description = "Whether mock exam-day preparation rules are satisfied."
  value       = local.exam_day_ready
}
