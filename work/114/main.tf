terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the dependency lock mock file.
  # Hint: use jsondecode(file("${path.module}/data/dependency-lock.json")).
  lock_data = {}

  # TODO 2: Read the providers list from the decoded object.
  # Hint: use local.lock_data.providers.
  providers = []

  # TODO 3: Build a map of locked provider versions keyed by provider source.
  # Hint: { for provider in local.providers : provider.source => provider.locked_version }.
  locked_provider_versions_by_source = {}

  # TODO 4: Build a map of provider constraints keyed by local provider name.
  # Hint: { for provider in local.providers : provider.local_name => provider.constraint }.
  provider_constraints_by_name = {}

  # TODO 5: Select provider local names that need terraform init -upgrade to reselect versions.
  # Hint: [for provider in local.providers : provider.local_name if provider.requires_upgrade_to_change].
  providers_requiring_upgrade = []

  # TODO 6: Flatten provider checksums into labels like "aws:h1:aws-linux-amd64".
  # Hint: use flatten with nested for expressions over providers and provider.hashes.
  checksum_labels = []

  # TODO 7: Build a scope summary for the dependency lock file.
  # Hint: provider dependencies are tracked; remote module version selections are not tracked.
  lock_file_scope = {
    file_name               = ""
    tracks_providers        = false
    tracks_remote_modules   = true
    normal_init             = ""
    reselect_dependencies   = ""
    remote_modules_observed = []
  }
}

output "lock_file_name" {
  description = "Terraform dependency lock file name."
  value       = local.lock_file_scope.file_name
}

output "locked_provider_versions_by_source" {
  description = "Locked provider versions keyed by provider source."
  value       = local.locked_provider_versions_by_source
}

output "provider_constraints_by_name" {
  description = "Provider version constraints keyed by local provider name."
  value       = local.provider_constraints_by_name
}

output "providers_requiring_upgrade" {
  description = "Providers that need terraform init -upgrade to reselect a version."
  value       = local.providers_requiring_upgrade
}

output "checksum_labels" {
  description = "Flattened provider checksum labels."
  value       = local.checksum_labels
}

output "lock_file_scope" {
  description = "What the dependency lock file tracks and which commands are relevant."
  value       = local.lock_file_scope
}
