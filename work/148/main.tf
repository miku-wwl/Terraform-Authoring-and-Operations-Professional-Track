terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Read and decode the exam pointer JSON mock file.
  # Hint: use jsondecode(file("${path.module}/data/exam_pointers.json")).
  exam = {}

  # TODO 2: Read the topics list from the decoded JSON object.
  # Hint: use local.exam.topics.
  topics = []

  # TODO 3: Build a map of topics keyed by topic id.
  # Hint: use { for topic in local.topics : topic.id => topic }.
  topic_map = {}

  # TODO 4: Select topic ids with priority greater than or equal to 5.
  # Hint: use a for expression with if topic.priority >= 5.
  high_priority_topic_ids = []

  # TODO 5: Select module refactor topic ids that use moved_block.
  # Hint: topic.category == "modules" && contains(topic.skills, "moved_block").
  module_refactor_topic_ids = []

  # TODO 6: Return provider alias workflow actions in the JSON order.
  # Hint: use [for step in local.exam.provider_alias_workflow : step.action].
  provider_alias_workflow_actions = []

  # TODO 7: Select AWS data source names that require filters.
  # Hint: use [for source in local.exam.data_sources : source.name if source.requires_filters].
  data_sources_requiring_filters = []

  # TODO 8: Build import lookup maps from local.exam.import_targets.
  # Hint 1: import_id_by_resource keys can use target.resource_type.
  # Hint 2: resources_with_generated_config_conflicts keys can use "${target.resource_type}.${target.resource_name}".
  # Hint 3: keep only targets where length(target.conflicting_arguments) > 0.
  import_id_by_resource                     = {}
  resources_with_generated_config_conflicts = {}
}

resource "terraform_data" "lesson" {
  input = {
    topic_count        = length(local.topics)
    high_priority_ids  = local.high_priority_topic_ids
    import_id_by_type  = local.import_id_by_resource
    generated_conflict = local.resources_with_generated_config_conflicts
  }
}

output "topic_count" {
  description = "Number of exam pointer topics decoded from data/exam_pointers.json."
  value       = length(local.topics)
}

output "topic_map" {
  description = "Exam pointer topics keyed by id."
  value       = local.topic_map
}

output "high_priority_topic_ids" {
  description = "Topic ids with priority >= 5."
  value       = local.high_priority_topic_ids
}

output "module_refactor_topic_ids" {
  description = "Module refactor topic ids that require moved_block knowledge."
  value       = local.module_refactor_topic_ids
}

output "provider_alias_workflow_actions" {
  description = "Ordered provider alias and configuration_aliases workflow actions."
  value       = local.provider_alias_workflow_actions
}

output "data_sources_requiring_filters" {
  description = "AWS data sources that usually require filters in exam-style tasks."
  value       = local.data_sources_requiring_filters
}

output "import_id_by_resource" {
  description = "Import ID type required for each AWS resource type."
  value       = local.import_id_by_resource
}

output "resources_with_generated_config_conflicts" {
  description = "Generated config conflict arguments keyed by Terraform resource address."
  value       = local.resources_with_generated_config_conflicts
}
