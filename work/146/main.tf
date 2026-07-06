terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the exam environment mock JSON file.
  # Hint: use jsondecode(file("${path.module}/data/exam_environment.json")).
  exam_environment = {}

  # TODO 2: Read exam.duration_hours and convert it to minutes.
  # Hint: local.exam_environment.exam.duration_hours * 60.
  exam_duration_minutes = 0

  # TODO 3: Read the exam flow stage list from the decoded JSON object.
  # Hint: local.exam_environment.exam_flow.stages.
  stages = []

  # TODO 4: Build a list containing every stage name in order.
  # Hint: [for stage in local.stages : stage.name].
  stage_names = []

  # TODO 5: Select only stage names where the stage type is lab.
  # Hint: [for stage in local.stages : stage.name if stage.type == "lab"].
  lab_stage_names = []

  # TODO 6: Build a scenario navigation summary map keyed by scenario id.
  # Each value should contain independent, has_architecture_diagram,
  # opens_vscode, opens_cli, has_validation_command, and right_sidebar_items.
  # Hint: contains(scenario.links, "vscode") and length(scenario.validation_commands) > 0.
  scenario_navigation_summary = {}

  # TODO 7: Split resource_policy into allowed and denied resource names.
  # Hint: use for expressions with if resource.allowed / if !resource.allowed.
  allowed_resource_names = []
  denied_resource_names  = []

  # TODO 8: Calculate MCQ, lab, and review minute budgets from strategy.time_split_percent.
  # Hint: local.exam_duration_minutes * percent / 100.
  time_budget_minutes = {
    mcq    = 0
    lab    = 0
    review = 0
  }
}

resource "terraform_data" "lesson" {
  input = {
    topic                  = "terraform professional exam environment navigation"
    exam_duration_minutes  = local.exam_duration_minutes
    stage_names            = local.stage_names
    lab_stage_names        = local.lab_stage_names
    allowed_resource_names = local.allowed_resource_names
    denied_resource_names  = local.denied_resource_names
  }
}

output "exam_duration_minutes" {
  description = "Total exam duration converted from hours to minutes."
  value       = local.exam_duration_minutes
}

output "stage_names" {
  description = "Exam environment stages in order."
  value       = local.stage_names
}

output "lab_stage_names" {
  description = "Only stages whose type is lab."
  value       = local.lab_stage_names
}

output "scenario_navigation_summary" {
  description = "Navigation hints and validation availability by lab scenario id."
  value       = local.scenario_navigation_summary
}

output "allowed_resource_names" {
  description = "Resource names allowed in the exam environment policy mock data."
  value       = local.allowed_resource_names
}

output "denied_resource_names" {
  description = "Resource names denied in the exam environment policy mock data."
  value       = local.denied_resource_names
}

output "time_budget_minutes" {
  description = "Suggested time budget based on the JSON strategy percentages."
  value       = local.time_budget_minutes
}
