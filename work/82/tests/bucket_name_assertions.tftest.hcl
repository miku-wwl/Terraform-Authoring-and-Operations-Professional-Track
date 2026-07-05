run "bucket_name_assertions_are_granular" {
  # TODO 1: Keep this test at plan stage.
  # The goal is to validate logic with assertions, not to create real resources.
  command = plan

  assert {
    # TODO 2: Replace false with a condition that verifies the bucket name
    # length is greater than 3 characters.
    # Hint: length(var.s3_bucket_name) > 3
    condition     = false
    error_message = "S3 bucket name must be greater than 3 characters."
  }

  assert {
    # TODO 3: Replace false with a condition that verifies the bucket name
    # length is less than 63 characters.
    # Hint: length(var.s3_bucket_name) < 63
    condition     = false
    error_message = "S3 bucket name must be less than 63 characters."
  }

  assert {
    # TODO 4: Replace false with a condition that verifies the output value
    # matches the computed length of var.s3_bucket_name.
    # Hint: output.bucket_name_length == length(var.s3_bucket_name)
    condition     = false
    error_message = "bucket_name_length output must match length(var.s3_bucket_name)."
  }
}
