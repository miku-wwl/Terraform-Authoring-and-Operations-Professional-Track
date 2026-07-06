# terraform fmt only formats the current directory by default.
# Use terraform fmt -recursive to also format tests/*.tftest.hcl.
# In CI/CD, terraform fmt -recursive -check -diff is commonly used
# to fail the pipeline when Terraform files are not formatted.
run "bucket_name_assertions_are_granular" {
  command = plan

  assert {
    condition     = length(var.s3_bucket_name) > 3
    error_message = "S3 bucket name must be greater than 3 characters."
  }

  assert {
    condition     = length(var.s3_bucket_name) < 63
    error_message = "S3 bucket name must be less than 63 characters."
  }

  assert {
    condition     = output.bucket_name_length == length(var.s3_bucket_name)
    error_message = "bucket_name_length output must match length(var.s3_bucket_name)."
  }
}
