run "terraform_professional_exam_tips_are_documented" {
  command = plan

  assert {
    condition     = output.backup_strategy_is_documented == true
    error_message = "Document that you should copy the scenarios folder before modifying any lab and mention Desktop/scenarios."
  }

  assert {
    condition     = output.exam_provider_strategy_is_documented == true
    error_message = "Document the exam-only strategy of explicitly adding the AWS provider block with scenario access key and secret key."
  }

  assert {
    condition     = output.scenario_triage_is_documented == true
    error_message = "Document that easy scenarios should be completed first."
  }

  assert {
    condition     = output.task_level_triage_is_documented == true
    error_message = "Document that independent tasks should be completed before returning to blocked tasks."
  }

  assert {
    condition     = output.documentation_familiarity_is_documented == true
    error_message = "Document that you should be familiar with Terraform documentation before the exam."
  }

  assert {
    condition     = output.validation_mindset_is_documented == true
    error_message = "Document that bad code is acceptable only in the exam when the validation command passes."
  }

  assert {
    condition     = output.two_attempt_mindset_is_documented == true
    error_message = "Document that there are two attempts, but you should prepare to pass on the first attempt."
  }

  assert {
    condition     = output.exam_provider_template_is_present == true
    error_message = "exam/provider_template.tf must include provider \"aws\", region, access_key, secret_key, EXAM_ACCESS_KEY, and EXAM_SECRET_KEY."
  }

  assert {
    condition     = output.docs_navigation_is_documented == true
    error_message = "exam/docs_navigation.md must mention Configuration Language, Terraform CLI, HCP Terraform, terraform_remote_state, S3 backend, and that S3 backend documentation can contain remote state data source examples."
  }

  assert {
    condition     = output.workflow_checklist_is_documented == true
    error_message = "exam/workflow_checklist.sh must include scenario backup, terraform fmt, terraform validate, terraform plan, and a validation command reminder after each completed task."
  }
}
