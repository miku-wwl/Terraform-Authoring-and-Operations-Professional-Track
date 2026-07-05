run "terraform_professional_orientation_is_modeled" {
  command = plan

  assert {
    condition = output.primary_domain_titles == [
      "Manage resource lifecycle",
      "Develop and troubleshoot dynamic configuration",
      "Terraform workflows",
      "Terraform modules",
      "Terraform provider",
      "HCP Terraform"
    ]
    error_message = "primary_domain_titles must list the six primary exam domains in order."
  }

  assert {
    condition = output.lab_based_domain_titles == [
      "Manage resource lifecycle",
      "Develop and troubleshoot dynamic configuration",
      "Terraform workflows",
      "Terraform modules",
      "Terraform provider"
    ]
    error_message = "lab_based_domain_titles must include the domains assessed through hands-on lab challenges."
  }

  assert {
    condition     = output.mcq_domain_titles == ["HCP Terraform"]
    error_message = "mcq_domain_titles must include only the HCP Terraform domain from the mock blueprint."
  }

  assert {
    condition = output.prerequisite_names == [
      "Terraform Associate or equivalent Terraform knowledge",
      "Linux CLI",
      "YAML",
      "JSON",
      "CSV"
    ]
    error_message = "prerequisite_names must list all prerequisites from data/course_overview.json."
  }

  assert {
    condition     = output.required_file_formats == ["YAML", "JSON", "CSV"]
    error_message = "required_file_formats must include only prerequisites whose type is file_format."
  }

  assert {
    condition     = try(output.course_sections_by_number["7"].title, "") == "AWS Integration Practicals"
    error_message = "course_sections_by_number must include section 7 as AWS Integration Practicals."
  }

  assert {
    condition     = try(output.course_sections_by_number["8"].kind, "") == "exam_prep"
    error_message = "course_sections_by_number must include section 8 as the exam preparation section."
  }

  assert {
    condition = output.cloud_provider_summary == {
      current_supported_provider        = "aws"
      future_expected_providers         = ["azure", "gcp"]
      provider_change_rule              = "core blueprint stays similar; practical implementation changes by provider"
      deep_provider_topics_section_title = "AWS Integration Practicals"
    }
    error_message = "cloud_provider_summary must summarize AWS support, future providers, blueprint stability, and section 7."
  }

  assert {
    condition = output.professional_exam_summary == {
      level                 = "professional"
      format                = "lab-based"
      duration_hours        = 4
      remote_workstation_os = "linux"
      main_challenge_style  = "scenario challenges"
      requires_hands_on     = true
      associate_format      = "mcq"
    }
    error_message = "professional_exam_summary must capture level, format, duration, remote OS, challenge style, hands-on nature, and Associate comparison."
  }
}
