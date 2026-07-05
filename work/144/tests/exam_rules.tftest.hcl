run "exam_rules_model_is_correct" {
  command = plan

  assert {
    condition     = output.portal_login_method == "GitHub"
    error_message = "portal_login_method must be read from data/exam_rules.json and equal GitHub."
  }

  assert {
    condition = output.id_requirement == {
      required_type                    = "unexpired government-issued physical ID"
      digital_id_allowed               = false
      name_match_required              = true
      name_change_notice_business_days = 3
      backup_id_recommendation         = "passport"
    }
    error_message = "id_requirement must model the physical ID and exact-name-match requirements correctly."
  }

  assert {
    condition = output.system_rules == [
      "run preflight system compatibility check before booking",
      "use Google Chrome browser",
      "use only one monitor",
      "close laptop screen when using an external monitor",
      "disable operating system and application notifications"
    ]
    error_message = "system_rules must include preflight, Chrome, one monitor, closed laptop screen, and disabled notifications."
  }

  assert {
    condition = output.physical_space_rules == [
      "no one else in the room",
      "room must be adequately lit",
      "desk and work area must be clear",
      "electronic items must not be operational",
      "background noise must be limited",
      "no phone or smartwatch in the room"
    ]
    error_message = "physical_space_rules must include room, lighting, desk, electronics, noise, and device rules."
  }

  assert {
    condition = output.behavior_rules == {
      may_leave_seat_without_permission     = false
      must_request_break_from_proctor       = true
      talking_or_mouthing_questions_allowed = false
      beverage_rule                         = "clear container with no writing"
      hands_must_remain_visible             = true
    }
    error_message = "behavior_rules must model proctor behavior requirements correctly."
  }

  assert {
    condition     = output.reschedule_cancel_notice_hours == 48
    error_message = "reschedule_cancel_notice_hours must be 48."
  }

  assert {
    condition = output.pre_exam_checklist == [
      "confirm GitHub login works for the exam portal",
      "verify account name matches every name on the ID",
      "test that the ID text is readable on camera",
      "complete the preflight compatibility check and save evidence",
      "prepare a clear desk and room scan path",
      "disable notifications before the exam"
    ]
    error_message = "pre_exam_checklist must be read from the JSON file in order."
  }

  assert {
    condition = output.risk_control_labels == [
      "blurry_id_camera: test ID readability on the webcam and keep passport as backup",
      "id_name_mismatch: contact HashiCorp certification support at least 3 business days before the appointment",
      "room_scan_issue: clear the desk and prepare to show under the table",
      "system_failure: run the compatibility check before booking and keep a screenshot",
      "unexpected_notification: disable OS, antivirus, chat, and browser notifications"
    ]
    error_message = "risk_control_labels must be generated from the risk_controls map as key: value strings."
  }
}
