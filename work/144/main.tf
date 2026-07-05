terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the exam rules mock file.
  # Hint: use jsondecode(file("${path.module}/data/exam_rules.json")).
  exam_rules = {}

  # TODO 2: Read the exam portal login method from the decoded JSON object.
  # Hint: use local.exam_rules.exam.portal_login_method.
  portal_login_method = ""

  # TODO 3: Build the ID requirement object from the decoded JSON object.
  # Hint: keep required_type, digital_id_allowed, name_match_required,
  # name_change_notice_business_days, and backup_id_recommendation.
  id_requirement = {
    required_type                    = ""
    digital_id_allowed               = true
    name_match_required              = false
    name_change_notice_business_days = 0
    backup_id_recommendation         = ""
  }

  # TODO 4: Read the system rules list from the decoded JSON object.
  # Hint: use local.exam_rules.system_rules.
  system_rules = []

  # TODO 5: Read the physical space rules list from the decoded JSON object.
  # Hint: use local.exam_rules.physical_space_rules.
  physical_space_rules = []

  # TODO 6: Build the behavior rules object from the decoded JSON object.
  # Hint: keep all behavior attributes from local.exam_rules.behavior.
  behavior_rules = {
    may_leave_seat_without_permission  = true
    must_request_break_from_proctor    = false
    talking_or_mouthing_questions_allowed = true
    beverage_rule                      = ""
    hands_must_remain_visible          = false
  }

  # TODO 7: Read the reschedule/cancel notice window in hours.
  # Hint: use local.exam_rules.scheduling.reschedule_cancel_notice_hours.
  reschedule_cancel_notice_hours = 0

  # TODO 8: Convert the risk_controls map into labels like "key: value".
  # Hint: use [for risk, action in local.exam_rules.risk_controls : "${risk}: ${action}"].
  risk_control_labels = []

  # TODO 9: Read the pre-exam checklist list from the decoded JSON object.
  # Hint: use local.exam_rules.pre_exam_checklist.
  pre_exam_checklist = []
}

resource "terraform_data" "lesson" {
  input = {
    topic                            = "HashiCorp exam appointment rules and requirements"
    portal_login_method              = local.portal_login_method
    id_required_type                 = local.id_requirement.required_type
    reschedule_cancel_notice_hours   = local.reschedule_cancel_notice_hours
    risk_control_count               = length(local.risk_control_labels)
  }
}

output "portal_login_method" {
  description = "Login method used by the HashiCorp certification exam portal."
  value       = local.portal_login_method
}

output "id_requirement" {
  description = "Identification requirements for the online proctored exam."
  value       = local.id_requirement
}

output "system_rules" {
  description = "Computer and browser rules before booking or sitting the exam."
  value       = local.system_rules
}

output "physical_space_rules" {
  description = "Room, desk, noise, and device requirements for the exam space."
  value       = local.physical_space_rules
}

output "behavior_rules" {
  description = "Exam behavior rules enforced by the proctor."
  value       = local.behavior_rules
}

output "reschedule_cancel_notice_hours" {
  description = "Minimum notice window for canceling or rescheduling the appointment."
  value       = local.reschedule_cancel_notice_hours
}

output "pre_exam_checklist" {
  description = "Checklist to complete before the exam appointment."
  value       = local.pre_exam_checklist
}

output "risk_control_labels" {
  description = "Risk-to-action labels generated from the risk_controls map."
  value       = local.risk_control_labels
}
