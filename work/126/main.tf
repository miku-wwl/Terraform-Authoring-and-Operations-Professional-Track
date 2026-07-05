terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the Sentinel mock file.
  # Hint: use jsondecode(file("${path.module}/data/sentinel_policy.json")).
  sentinel_config = {}

  # TODO 2: Read the feature name from the decoded JSON object.
  # Hint: use local.sentinel_config.feature.
  feature_name = ""

  # TODO 3: Read whether Sentinel requires a paid governance plan.
  # Hint: use local.sentinel_config.availability.requires_paid_plan.
  requires_paid_plan = false

  # TODO 4: Read the workspace name from the decoded JSON object.
  # Hint: use local.sentinel_config.workspace.name.
  workspace_name = ""

  # TODO 5: Build the policy set object from the decoded JSON object.
  # Hint: keep name, scope, and workspaces.
  policy_set = {
    name       = ""
    scope      = ""
    workspaces = []
  }

  # TODO 6: Build the policy object from the decoded JSON object.
  # Hint: keep name, rule, enforcement_mode, and required_tag_key.
  policy = {
    name             = ""
    rule             = ""
    enforcement_mode = ""
    required_tag_key = ""
  }

  # TODO 7: Read enforcement modes and run checks from the decoded JSON object.
  # Hint: use local.sentinel_config.enforcement_modes and local.sentinel_config.run_checks.
  enforcement_modes = []
  run_checks        = []

  # TODO 8: Build the two-layer production guardrail list.
  # Hint: Sentinel checks Terraform runs; AWS Config checks cloud-side resource compliance.
  production_guardrail_layers = []
}

resource "terraform_data" "lesson" {
  input = {
    topic            = "sentinel policy as code and policy sets"
    feature_name     = local.feature_name
    workspace_name   = local.workspace_name
    policy_set_name  = local.policy_set.name
    policy_name      = local.policy.name
    enforcement_mode = local.policy.enforcement_mode
  }
}

output "feature_name" {
  description = "HashiCorp policy as code feature name."
  value       = local.feature_name
}

output "requires_paid_plan" {
  description = "Whether the feature requires a paid governance/trial plan in HCP Terraform."
  value       = local.requires_paid_plan
}

output "workspace_name" {
  description = "Workspace associated with the policy set."
  value       = local.workspace_name
}

output "policy_set" {
  description = "Sentinel policy set configuration model."
  value       = local.policy_set
}

output "policy" {
  description = "Sentinel policy configuration model."
  value       = local.policy
}

output "enforcement_modes" {
  description = "Supported Sentinel enforcement modes discussed in this lab."
  value       = local.enforcement_modes
}

output "run_checks" {
  description = "HCP Terraform run checks visible when governance features are enabled."
  value       = local.run_checks
}

output "production_guardrail_layers" {
  description = "Two-layer production control model: IaC policy check plus cloud-side compliance."
  value       = local.production_guardrail_layers
}
