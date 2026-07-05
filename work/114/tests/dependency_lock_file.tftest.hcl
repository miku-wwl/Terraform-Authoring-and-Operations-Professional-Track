run "dependency_lock_file_model_is_correct" {
  command = plan

  assert {
    condition     = output.lock_file_name == ".terraform.lock.hcl"
    error_message = "lock_file_name must come from data/dependency-lock.json and equal .terraform.lock.hcl."
  }

  assert {
    condition = output.locked_provider_versions_by_source == {
      "registry.terraform.io/hashicorp/aws"    = "4.62.0"
      "registry.terraform.io/hashicorp/local"  = "2.5.3"
      "registry.terraform.io/hashicorp/random" = "3.7.2"
    }
    error_message = "locked_provider_versions_by_source must map each provider source to the locked version."
  }

  assert {
    condition = output.provider_constraints_by_name == {
      aws    = ">= 4.0, < 5.0"
      local  = "~> 2.5"
      random = ">= 3.6, < 4.0"
    }
    error_message = "provider_constraints_by_name must map local provider names to version constraints."
  }

  assert {
    condition     = output.providers_requiring_upgrade == ["aws"]
    error_message = "providers_requiring_upgrade must only include providers whose requested version differs from the locked selection."
  }

  assert {
    condition = output.checksum_labels == [
      "aws:h1:aws-linux-amd64",
      "aws:zh:aws-darwin-amd64",
      "local:h1:local-linux-amd64",
      "random:h1:random-linux-amd64",
      "random:zh:random-darwin-amd64"
    ]
    error_message = "checksum_labels must flatten all provider hashes into local_name:hash labels."
  }

  assert {
    condition = output.lock_file_scope == {
      file_name               = ".terraform.lock.hcl"
      tracks_providers        = true
      tracks_remote_modules   = false
      normal_init             = "terraform init -input=false"
      reselect_dependencies   = "terraform init -upgrade -input=false"
      remote_modules_observed = ["ec2-instance", "vpc"]
    }
    error_message = "lock_file_scope must show provider dependencies are tracked, remote module selections are not, and init -upgrade is used to reselect versions."
  }
}
