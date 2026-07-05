run "moved_block_module_migration_is_correct" {
  command = plan

  assert {
    condition     = output.module_bucket_config.bucket == "kplabs-moved-module-practical-099"
    error_message = "The module must keep the exact legacy bucket name instead of creating a new bucket identity."
  }

  assert {
    condition     = output.module_bucket_config.block_public_access == true
    error_message = "The reusable module should still manage the simulated public access block setting."
  }

  assert {
    condition     = output.main_has_moved_block == true
    error_message = "main.tf must contain a moved block for the migration."
  }

  assert {
    condition     = output.moved_from_is_legacy_resource == true
    error_message = "moved.from must point to the old root resource address terraform_data.legacy_bucket."
  }

  assert {
    condition     = output.moved_to_is_module_resource == true
    error_message = "moved.to must point to the exact module resource address module.s3_bucket.terraform_data.bucket, not only module.s3_bucket."
  }

  assert {
    condition     = output.active_legacy_resource_count == 0
    error_message = "The active legacy root resource block must not remain after migration to the module."
  }
}
