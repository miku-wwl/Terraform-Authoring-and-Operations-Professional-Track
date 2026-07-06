terraform {
  required_version = ">= 1.6.0"
}

variable "bucket_name" {
  type        = string
  description = "Bucket name candidate that will be checked by Terraform test."
  default     = "hi-from-zeal"
}

locals {
  bucket_name = var.bucket_name

  has_valid_length = length(local.bucket_name) >= 3 && length(local.bucket_name) <= 63

  has_allowed_characters = can(regex("^[a-z0-9.-]+$", local.bucket_name))

  does_not_start_with_reserved_prefix = !startswith(local.bucket_name, "xn--")

  invalid_reasons = compact([
    local.has_valid_length ? "" : "bucket name must be between 3 and 63 characters",
    local.has_allowed_characters ? "" : "bucket name must use lowercase letters, numbers, dots, and hyphens only",
    local.does_not_start_with_reserved_prefix ? "" : "bucket name must not start with xn--"
  ])

  is_bucket_name_valid = alltrue([
    local.has_valid_length,
    local.has_allowed_characters,
    local.does_not_start_with_reserved_prefix
  ])

  validation_summary = {
    bucket_name     = local.bucket_name
    valid           = local.is_bucket_name_valid
    invalid_reasons = local.invalid_reasons
  }
}

resource "terraform_data" "bucket_review" {
  input = local.validation_summary
}

output "bucket_name" {
  description = "The bucket name candidate being checked."
  value       = local.bucket_name
}

output "has_valid_length" {
  description = "Whether bucket_name has 3 to 63 characters."
  value       = local.has_valid_length
}

output "has_allowed_characters" {
  description = "Whether bucket_name only uses lowercase letters, numbers, dots, and hyphens."
  value       = local.has_allowed_characters
}

output "does_not_start_with_reserved_prefix" {
  description = "Whether bucket_name avoids the reserved xn-- prefix."
  value       = local.does_not_start_with_reserved_prefix
}

output "invalid_reasons" {
  description = "Validation errors found for bucket_name."
  value       = local.invalid_reasons
}

output "is_bucket_name_valid" {
  description = "Final validation result for bucket_name."
  value       = local.is_bucket_name_valid
}

output "validation_summary" {
  description = "Combined validation summary used by the mock terraform_data resource."
  value       = local.validation_summary
}

output "bucket_review_input" {
  description = "Input stored in the terraform_data mock resource."
  value       = terraform_data.bucket_review.input
}
