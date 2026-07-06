run "exam_pointer_model_is_correct" {
  command = plan

  assert {
    condition     = output.topic_count == 16
    error_message = "topic_count must decode all exam pointer topics from data/exam_pointers.json."
  }

  assert {
    condition = keys(output.topic_map) == [
      "aws.provider.credentials",
      "aws.provider.default_tags",
      "data.sources.filters",
      "files.decode",
      "iam.basics",
      "import.conflicts",
      "import.workflow",
      "lifecycle.meta",
      "modules.basics",
      "modules.refactor.rename",
      "modules.refactor.split",
      "providers.alias",
      "providers.configuration_aliases",
      "remote_state.s3",
      "s3.force_destroy",
      "security_group.rules"
    ]
    error_message = "topic_map must key every topic by its id."
  }

  assert {
    condition = output.high_priority_topic_ids == [
      "modules.basics",
      "modules.refactor.rename",
      "modules.refactor.split",
      "providers.alias",
      "providers.configuration_aliases",
      "import.workflow",
      "import.conflicts"
    ]
    error_message = "high_priority_topic_ids must select topics where priority is greater than or equal to 5."
  }

  assert {
    condition = output.module_refactor_topic_ids == [
      "modules.refactor.rename",
      "modules.refactor.split"
    ]
    error_message = "module_refactor_topic_ids must select module topics whose skills include moved_block."
  }

  assert {
    condition = output.provider_alias_workflow_actions == [
      "define default aws provider",
      "define aliased aws provider, for example aws.mumbai",
      "declare configuration_aliases in required_providers",
      "pass providers map to module block",
      "set provider meta-argument on resources that need alias"
    ]
    error_message = "provider_alias_workflow_actions must preserve the root-to-child provider alias workflow order."
  }

  assert {
    condition = output.data_sources_requiring_filters == [
      "aws_ami",
      "aws_subnet"
    ]
    error_message = "data_sources_requiring_filters must keep only data sources whose requires_filters value is true."
  }

  assert {
    condition = output.import_id_by_resource == {
      aws_instance       = "instance id"
      aws_iam_policy     = "policy arn"
      aws_security_group = "security group id"
    }
    error_message = "import_id_by_resource must map each AWS resource type to the correct import ID kind."
  }

  assert {
    condition = output.resources_with_generated_config_conflicts == {
      "aws_instance.test" = ["ipv6_address_count", "ipv6_addresses"]
    }
    error_message = "resources_with_generated_config_conflicts must include only resources with generated config conflict arguments."
  }
}
