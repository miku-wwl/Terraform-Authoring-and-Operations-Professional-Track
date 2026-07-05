run "terraform_settings_are_correct" {
  command = plan

  assert {
    condition     = output.terraform_required_version == ">= 1.5.0, < 2.0.0"
    error_message = "terraform_required_version must record the required Terraform CLI constraint."
  }

  assert {
    condition     = output.terraform_provider_source == "terraform.io/builtin/terraform"
    error_message = "terraform_provider_source must be terraform.io/builtin/terraform."
  }

  assert {
    condition     = output.pinned_external_provider_example == "hashicorp/aws:5.54.1"
    error_message = "pinned_external_provider_example must be hashicorp/aws:5.54.1."
  }

  assert {
    condition = output.settings_features == [
      "required_version",
      "required_providers",
      "backend",
      "experiments",
      "provider_meta"
    ]
    error_message = "settings_features must list the Terraform settings features from the lesson."
  }

  assert {
    condition = output.block_responsibilities == {
      provider_block  = "runtime provider configuration such as region and credentials"
      terraform_block = "project-level Terraform behavior such as versions, providers, backend and experiments"
    }
    error_message = "block_responsibilities must clearly separate provider block and terraform block responsibilities."
  }

  assert {
    condition = output.settings_summary == {
      terraform_required_version       = ">= 1.5.0, < 2.0.0"
      terraform_provider_source        = "terraform.io/builtin/terraform"
      pinned_external_provider_example = "hashicorp/aws:5.54.1"
      settings_features = [
        "required_version",
        "required_providers",
        "backend",
        "experiments",
        "provider_meta"
      ]
      block_responsibilities = {
        provider_block  = "runtime provider configuration such as region and credentials"
        terraform_block = "project-level Terraform behavior such as versions, providers, backend and experiments"
      }
    }
    error_message = "settings_summary must combine all required Terraform settings values."
  }
}
