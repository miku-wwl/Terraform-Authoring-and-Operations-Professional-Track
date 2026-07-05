resource "terraform_data" "bucket" {
  input = {
    bucket              = var.bucket
    block_public_access = var.block_public_access
    managed_by          = "module"
  }
}

output "bucket_config" {
  description = "Simulated bucket config produced by this module."
  value       = terraform_data.bucket.input
}
