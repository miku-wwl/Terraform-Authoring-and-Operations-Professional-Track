terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the backend catalog JSON file.
  # Hint: use jsondecode(file("${path.module}/data/backend-catalog.json")).backends.
  backend_catalog = []

  # TODO 2: Build a map of backends keyed by backend name.
  # Hint: use { for backend in local.backend_catalog : backend.name => backend }.
  backends_by_name = {}

  # TODO 3: Select names of remote backends.
  # Hint: use a for expression with if backend.kind == "remote".
  remote_backend_names = []

  # TODO 4: Select remote backends that support state locking.
  # Hint: require both backend.kind == "remote" and backend.supports_locking.
  collaboration_ready_backend_names = []

  # TODO 5: Select backend names that require access credentials.
  # Hint: filter by backend.requires_credentials.
  credential_required_backend_names = []

  # TODO 6: Build an AWS team backend recommendation object from the s3 backend.
  # Expected keys: name, state_location, locking_note.
  # Hint: read local.backends_by_name.s3 and create a short locking note.
  aws_team_backend_recommendation = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic                    = "terraform backend and remote state"
    recommended_backend_name = try(local.aws_team_backend_recommendation.name, null)
  }
}

output "backend_catalog" {
  description = "Backend catalog decoded from data/backend-catalog.json."
  value       = local.backend_catalog
}

output "backends_by_name" {
  description = "Backends keyed by backend name."
  value       = local.backends_by_name
}

output "remote_backend_names" {
  description = "Backend names whose kind is remote."
  value       = local.remote_backend_names
}

output "collaboration_ready_backend_names" {
  description = "Remote backend names that support state locking."
  value       = local.collaboration_ready_backend_names
}

output "credential_required_backend_names" {
  description = "Backend names that require access credentials."
  value       = local.credential_required_backend_names
}

output "aws_team_backend_recommendation" {
  description = "Recommended remote backend object for an AWS team."
  value       = local.aws_team_backend_recommendation
}
