run "valid_bucket_name_passes_plan_checks" {
  command = plan

  variables {
    bucket_name = "hi-from-zeal"
  }

  assert {
    condition     = output.has_valid_length == true
    error_message = "A valid bucket name must pass the 3 to 63 character length check."
  }

  assert {
    condition     = output.has_allowed_characters == true
    error_message = "A valid bucket name must only contain lowercase letters, numbers, dots, and hyphens."
  }

  assert {
    condition     = output.does_not_start_with_reserved_prefix == true
    error_message = "A valid bucket name must not start with the reserved xn-- prefix."
  }

  assert {
    condition     = output.is_bucket_name_valid == true
    error_message = "hi-from-zeal should be treated as a valid bucket name candidate."
  }

  assert {
    condition     = length(output.invalid_reasons) == 0
    error_message = "Valid bucket names should not produce invalid_reasons."
  }
}

run "too_short_bucket_name_is_reported" {
  command = plan

  variables {
    bucket_name = "hi"
  }

  assert {
    condition     = output.has_valid_length == false
    error_message = "A two-character bucket name must fail the length check."
  }

  assert {
    condition     = contains(output.invalid_reasons, "bucket name must be between 3 and 63 characters")
    error_message = "too-short names must include a clear length error message."
  }

  assert {
    condition     = output.is_bucket_name_valid == false
    error_message = "A too-short bucket name must not be marked valid."
  }
}

run "too_long_bucket_name_is_reported" {
  command = plan

  variables {
    bucket_name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  }

  assert {
    condition     = output.has_valid_length == false
    error_message = "A 64-character bucket name must fail the length check."
  }

  assert {
    condition     = contains(output.invalid_reasons, "bucket name must be between 3 and 63 characters")
    error_message = "too-long names must include a clear length error message."
  }

  assert {
    condition     = output.is_bucket_name_valid == false
    error_message = "A too-long bucket name must not be marked valid."
  }
}

run "uppercase_bucket_name_is_reported" {
  command = plan

  variables {
    bucket_name = "Team-Bucket"
  }

  assert {
    condition     = output.has_allowed_characters == false
    error_message = "Uppercase letters must fail the allowed character check."
  }

  assert {
    condition     = contains(output.invalid_reasons, "bucket name must use lowercase letters, numbers, dots, and hyphens only")
    error_message = "invalid character cases must include a clear character-set error message."
  }

  assert {
    condition     = output.is_bucket_name_valid == false
    error_message = "A bucket name with uppercase letters must not be marked valid."
  }
}

run "reserved_prefix_bucket_name_is_reported" {
  command = plan

  variables {
    bucket_name = "xn--team-bucket"
  }

  assert {
    condition     = output.does_not_start_with_reserved_prefix == false
    error_message = "Names that start with xn-- must fail the reserved prefix check."
  }

  assert {
    condition     = contains(output.invalid_reasons, "bucket name must not start with xn--")
    error_message = "reserved prefix cases must include a clear prefix error message."
  }

  assert {
    condition     = output.is_bucket_name_valid == false
    error_message = "A bucket name with a reserved prefix must not be marked valid."
  }
}
