terraform {
  required_version = ">= 1.5.0"
}

locals {
  strategy_notes    = lower(file("${path.module}/exam/exam_strategy.md"))
  provider_template = lower(file("${path.module}/exam/provider_template.tf"))
  docs_notes        = lower(file("${path.module}/exam/docs_navigation.md"))
  workflow_script   = lower(file("${path.module}/exam/workflow_checklist.sh"))

  backup_strategy_is_documented = alltrue([
    strcontains(local.strategy_notes, "copy the scenarios folder before modifying any lab"),
    strcontains(local.strategy_notes, "desktop/scenarios")
  ])

  exam_provider_strategy_is_documented = strcontains(
    local.strategy_notes,
    "in the exam, explicitly add the aws provider block with the scenario access key and secret key"
  )

  scenario_triage_is_documented = strcontains(
    local.strategy_notes,
    "choose easy scenarios first"
  )

  task_level_triage_is_documented = strcontains(
    local.strategy_notes,
    "complete independent tasks before returning to blocked tasks"
  )

  documentation_familiarity_is_documented = strcontains(
    local.strategy_notes,
    "be familiar with terraform documentation before the exam"
  )

  validation_mindset_is_documented = strcontains(
    local.strategy_notes,
    "bad code is acceptable only in the exam when the validation command passes"
  )

  two_attempt_mindset_is_documented = strcontains(
    local.strategy_notes,
    "there are two attempts, but prepare to pass on the first attempt"
  )

  exam_provider_template_is_present = alltrue([
    strcontains(local.provider_template, "provider \"aws\""),
    strcontains(local.provider_template, "region"),
    strcontains(local.provider_template, "access_key"),
    strcontains(local.provider_template, "secret_key"),
    strcontains(local.provider_template, "exam_access_key"),
    strcontains(local.provider_template, "exam_secret_key")
  ])

  docs_navigation_is_documented = alltrue([
    strcontains(local.docs_notes, "configuration language"),
    strcontains(local.docs_notes, "terraform cli"),
    strcontains(local.docs_notes, "hcp terraform"),
    strcontains(local.docs_notes, "terraform_remote_state"),
    strcontains(local.docs_notes, "s3 backend"),
    strcontains(local.docs_notes, "s3 backend documentation can contain remote state data source examples")
  ])

  workflow_checklist_is_documented = alltrue([
    strcontains(local.workflow_script, "cp -r ~/desktop/scenarios ~/desktop/scenarios-backup"),
    strcontains(local.workflow_script, "terraform fmt"),
    strcontains(local.workflow_script, "terraform validate"),
    strcontains(local.workflow_script, "terraform plan"),
    strcontains(local.workflow_script, "validation command"),
    strcontains(local.workflow_script, "completed task")
  ])

  exam_tip_categories = {
    backup          = "copy base scenarios before editing"
    provider_block  = "exam-only explicit AWS provider credentials"
    scenario_order  = "choose easy scenarios first"
    task_order      = "finish independent tasks before blocked tasks"
    documentation   = "know Terraform docs and remote state example locations"
    validation      = "use scenario validation commands to confirm results"
    mindset         = "two attempts exist, but prepare to pass on the first attempt"
  }
}

resource "terraform_data" "lesson" {
  input = {
    topic      = "terraform professional exam practical tips"
    categories = local.exam_tip_categories
  }
}

output "backup_strategy_is_documented" {
  description = "Whether base scenario backup guidance is documented."
  value       = local.backup_strategy_is_documented
}

output "exam_provider_strategy_is_documented" {
  description = "Whether exam-only provider block strategy is documented."
  value       = local.exam_provider_strategy_is_documented
}

output "scenario_triage_is_documented" {
  description = "Whether easy-scenario-first triage is documented."
  value       = local.scenario_triage_is_documented
}

output "task_level_triage_is_documented" {
  description = "Whether task-level dependency triage is documented."
  value       = local.task_level_triage_is_documented
}

output "documentation_familiarity_is_documented" {
  description = "Whether Terraform documentation familiarity is documented."
  value       = local.documentation_familiarity_is_documented
}

output "validation_mindset_is_documented" {
  description = "Whether exam-only validation mindset is documented."
  value       = local.validation_mindset_is_documented
}

output "two_attempt_mindset_is_documented" {
  description = "Whether two-attempt mindset is documented."
  value       = local.two_attempt_mindset_is_documented
}

output "exam_provider_template_is_present" {
  description = "Whether static provider template includes the exam-only AWS credential fields."
  value       = local.exam_provider_template_is_present
}

output "docs_navigation_is_documented" {
  description = "Whether important Terraform documentation sections and remote state navigation are documented."
  value       = local.docs_navigation_is_documented
}

output "workflow_checklist_is_documented" {
  description = "Whether backup, fmt, validate, plan, and validation-command checklist items are documented."
  value       = local.workflow_checklist_is_documented
}

output "exam_tip_categories" {
  description = "Summary map of Terraform Professional exam tip categories."
  value       = local.exam_tip_categories
}
