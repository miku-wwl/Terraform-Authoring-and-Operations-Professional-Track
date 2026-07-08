terraform {
  required_version = ">= 1.5.0"
}

locals {
  # This is the original bucket name from the old long-lived configuration.
  legacy_bucket_name = "kplabs-moved-module-practical-099"
}

# Historical context only:
# The bucket used to be managed directly by this root resource address.
# During migration, this active resource block is removed and replaced by a module call.
#
# resource "terraform_data" "legacy_bucket" {
#   input = {
#     bucket = local.legacy_bucket_name
#   }
# }

module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket = local.legacy_bucket_name

  # This simulates extra settings that a reusable S3 module may manage.
  block_public_access = true
}
moved {
  from = terraform_data.legacy_bucket
  to   = module.s3_bucket.terraform_data.bucket
}

locals {
  main_tf = file("${path.module}/main.tf")

  main_has_moved_block = length(regexall("(?m)^\\s*moved\\s*\\{", local.main_tf)) > 0
  moved_from_is_legacy_resource = length(regexall(
    "(?m)^\\s*from\\s*=\\s*terraform_data\\.legacy_bucket",
    local.main_tf
  )) > 0
  moved_to_is_module_resource = length(regexall(
    "(?m)^\\s*to\\s*=\\s*module\\.s3_bucket\\.terraform_data\\.bucket",
    local.main_tf
  )) > 0

  # This only catches active, non-commented legacy resource declarations.
  active_legacy_resource_count = length(regexall(
    "(?m)^\\s*resource\\s+\\\"terraform_data\\\"\\s+\\\"legacy_bucket\\\"",
    local.main_tf
  ))
}

resource "terraform_data" "lesson" {
  input = {
    topic          = "moved block resource to module migration"
    old_address    = "terraform_data.legacy_bucket"
    target_address = "module.s3_bucket.terraform_data.bucket"
  }
}

output "module_bucket_config" {
  description = "The simulated S3 bucket configuration produced by the reusable module."
  value       = module.s3_bucket.bucket_config
}

output "main_has_moved_block" {
  description = "Whether main.tf contains a moved block."
  value       = local.main_has_moved_block
}

output "moved_from_is_legacy_resource" {
  description = "Whether moved.from points to terraform_data.legacy_bucket."
  value       = local.moved_from_is_legacy_resource
}

output "moved_to_is_module_resource" {
  description = "Whether moved.to points to module.s3_bucket.terraform_data.bucket."
  value       = local.moved_to_is_module_resource
}

output "active_legacy_resource_count" {
  description = "Number of active legacy root resource declarations still present in main.tf."
  value       = local.active_legacy_resource_count
}
