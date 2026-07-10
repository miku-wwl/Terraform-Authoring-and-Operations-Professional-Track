run "dependency_lock_file_was_reselected" {
  command = plan

  assert {
    condition = strcontains(
      file("${path.module}/.terraform.lock.hcl"),
      "provider \"registry.terraform.io/hashicorp/local\""
    )
    error_message = ".terraform.lock.hcl must contain the hashicorp/local provider entry."
  }

  assert {
    condition = strcontains(
      file("${path.module}/.terraform.lock.hcl"),
      "version     = \"2.5.3\""
    )
    error_message = "The lock file must select local provider 2.5.3. Change main.tf, then run terraform init -upgrade."
  }

  assert {
    condition = strcontains(
      file("${path.module}/.terraform.lock.hcl"),
      "constraints = \"2.5.3\""
    )
    error_message = "The lock file constraint must be updated to 2.5.3."
  }

  assert {
    condition = strcontains(
      file("${path.module}/.terraform.lock.hcl"),
      "hashes = ["
    )
    error_message = "The lock file must contain provider package checksums."
  }
}
