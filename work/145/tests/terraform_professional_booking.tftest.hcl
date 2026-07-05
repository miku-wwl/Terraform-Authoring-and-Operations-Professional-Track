run "terraform_professional_booking_workflow_is_modeled_correctly" {
  command = plan

  assert {
    condition     = output.official_domain_suffix == "hashicorp.com"
    error_message = "official_domain_suffix must come from data/terraform-professional-booking.json."
  }

  assert {
    condition     = output.login_provider == "GitHub"
    error_message = "login_provider must read GitHub from the portal object."
  }

  assert {
    condition     = output.candidate_name_must_match_government_id == true
    error_message = "candidate_name_must_match_government_id must be true."
  }

  assert {
    condition     = output.professional_exam_name == "Terraform Authoring and Operations Professional"
    error_message = "professional_exam_name must select the exam where level is professional."
  }

  assert {
    condition     = output.professional_base_duration_minutes == 240
    error_message = "professional_base_duration_minutes must be 240."
  }

  assert {
    condition     = output.professional_attempts_included == 2
    error_message = "professional_attempts_included must be 2 for the professional exam in this mock data."
  }

  assert {
    condition = output.system_compatibility_checks == [
      "webcam",
      "microphone",
      "screen_sharing",
      "browser",
      "network"
    ]
    error_message = "system_compatibility_checks must preserve all preflight checks in order."
  }

  assert {
    condition     = output.extra_time_accommodation_names == ["english_not_first_language_extra_time"]
    error_message = "extra_time_accommodation_names must include only accommodations where extra_minutes > 0."
  }

  assert {
    condition     = output.professional_duration_with_extra_time_minutes == 270
    error_message = "professional_duration_with_extra_time_minutes must add 240 base minutes and 30 extra minutes."
  }

  assert {
    condition = output.booking_step_names == [
      "verify_official_hashicorp_domain",
      "sign_in_with_github",
      "confirm_name_matches_government_id",
      "open_exam_platform",
      "run_system_compatibility_check",
      "choose_professional_exam",
      "request_accommodation_if_eligible",
      "select_date_time_and_location",
      "pay_by_card_or_voucher",
      "verify_receipt_and_confirmation_email",
      "start_exam_early_for_proctor_checks"
    ]
    error_message = "booking_step_names must return all booking steps in order."
  }

  assert {
    condition     = output.booking_steps_by_order["5"].name == "run_system_compatibility_check" && output.booking_steps_by_order["11"].stage == "exam_day"
    error_message = "booking_steps_by_order must key each step by tostring(step.order)."
  }

  assert {
    condition     = output.payment_options_by_name["credit_card"].typical_use == "first_attempt" && output.payment_options_by_name["voucher"].typical_use == "second_attempt_or_discount"
    error_message = "payment_options_by_name must key payment options by name."
  }

  assert {
    condition     = output.exam_day_ready == true
    error_message = "exam_day_ready must verify screenshot recommendation, confirmation email, and 20-30 minute early-start window."
  }
}
