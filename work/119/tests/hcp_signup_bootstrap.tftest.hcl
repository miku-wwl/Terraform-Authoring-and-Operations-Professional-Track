run "hcp_signup_bootstrap_is_modelled_correctly" {
  command = plan

  assert {
    condition     = output.portal_url == "https://app.terraform.io"
    error_message = "portal_url must be read from data/hcp_signup.json and equal https://app.terraform.io."
  }

  assert {
    condition     = output.account_fields == ["username", "email", "password"]
    error_message = "account_fields must come from the mock JSON account_creation.required_fields list."
  }

  assert {
    condition = output.account_identity == {
      username = "lab119-user"
      email    = "student+lab119@example.com"
    }
    error_message = "account_identity must use the safe lab username and plus-addressed practice email."
  }

  assert {
    condition     = !contains(keys(output.account_identity), "password")
    error_message = "account_identity must not expose a password."
  }

  assert {
    condition     = output.email_verification_required == true
    error_message = "email_verification_required must be read from the mock JSON file and be true."
  }

  assert {
    condition     = output.organization_name == "lab119-learning-org"
    error_message = "organization_name must be lab119-learning-org."
  }

  assert {
    condition     = output.organization_slug == "lab119-learning-org"
    error_message = "organization_slug must normalize organization_name with lower() and replace()."
  }

  assert {
    condition = output.onboarding_checklist == [
      "Open https://app.terraform.io",
      "Create account with username/email/password",
      "Verify email address",
      "Create first organization lab119-learning-org"
    ]
    error_message = "onboarding_checklist must describe the account and organization bootstrap flow in order."
  }
}
