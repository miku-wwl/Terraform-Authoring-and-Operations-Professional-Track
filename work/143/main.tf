terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the Terraform Professional course overview mock file.
  # Hint: use jsondecode(file("${path.module}/data/course_overview.json")).
  mock = {}

  # TODO 2: Read the exam object from the decoded JSON object.
  # Hint: use local.mock.exam.
  exam = {}

  # TODO 3: List the six primary exam domain titles in order.
  # Hint: use [for domain in local.mock.primary_domains : domain.title].
  primary_domain_titles = []

  # TODO 4: Select primary domain titles assessed through lab challenges.
  # Hint: filter domains where domain.assessment == "lab".
  lab_based_domain_titles = []

  # TODO 5: Select primary domain titles assessed through MCQ questions.
  # Hint: filter domains where domain.assessment == "mcq".
  mcq_domain_titles = []

  # TODO 6: List all prerequisite names.
  # Hint: use [for item in local.mock.prerequisites : item.name].
  prerequisite_names = []

  # TODO 7: List prerequisite names whose type is file_format.
  # Hint: filter prerequisites where item.type == "file_format".
  required_file_formats = []

  # TODO 8: Build a map of course sections keyed by section number as a string.
  # Hint: use { for section in local.mock.course_sections : tostring(section.number) => section }.
  course_sections_by_number = {}

  # TODO 9: Build a cloud provider summary object.
  # Required keys: current_supported_provider, future_expected_providers,
  # provider_change_rule, deep_provider_topics_section_title.
  # Hint: use local.mock.cloud_provider and local.course_sections_by_number.
  cloud_provider_summary = {}

  # TODO 10: Build a professional exam summary object.
  # Required keys: level, format, duration_hours, remote_workstation_os,
  # main_challenge_style, requires_hands_on, associate_format.
  professional_exam_summary = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic        = "terraform professional certification orientation"
    domain_count = length(local.primary_domain_titles)
    exam_format  = try(local.professional_exam_summary.format, null)
  }
}

output "primary_domain_titles" {
  description = "The six primary Terraform Professional exam domains."
  value       = local.primary_domain_titles
}

output "lab_based_domain_titles" {
  description = "Primary domains assessed through lab-based challenges."
  value       = local.lab_based_domain_titles
}

output "mcq_domain_titles" {
  description = "Primary domains assessed through MCQ questions."
  value       = local.mcq_domain_titles
}

output "prerequisite_names" {
  description = "Prerequisites and recommended background for the professional course."
  value       = local.prerequisite_names
}

output "required_file_formats" {
  description = "File formats called out by the course introduction."
  value       = local.required_file_formats
}

output "course_sections_by_number" {
  description = "Course sections keyed by section number."
  value       = local.course_sections_by_number
}

output "cloud_provider_summary" {
  description = "Summary of cloud provider support and provider-specific practicals."
  value       = local.cloud_provider_summary
}

output "professional_exam_summary" {
  description = "Summary of the Terraform Professional exam orientation."
  value       = local.professional_exam_summary
}
