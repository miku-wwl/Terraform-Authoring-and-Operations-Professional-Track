run "localstack_iam_credentials_are_understood" {
  command = apply

  assert {
    condition     = output.iam_user_name == "tf-pro-lab-134-operator"
    error_message = "The IAM user must use the lab's expected name."
  }

  assert {
    condition     = output.password_reset_required
    error_message = "The generated console password must require reset at first sign-in."
  }

  assert {
    condition     = output.access_key_status == "Active"
    error_message = "The generated Access Key must be Active."
  }

  assert {
    condition     = length(output.access_key_id) > 0 && length(output.access_key_secret) > 0
    error_message = "The Access Key ID and Secret Access Key must both be generated."
  }

  assert {
    condition     = length(output.generated_console_password) >= 20
    error_message = "The generated console password must contain at least 20 characters."
  }
}
