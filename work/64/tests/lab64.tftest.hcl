run "flatten_and_distinct_expressions_are_correct" {
  command = apply

  assert {
    condition = output.all_service_names == [
      "api",
      "worker",
      "api",
      "billing",
      "worker",
      "search"
    ]
    error_message = "all_service_names must flatten service_groups into one list."
  }

  assert {
    condition = output.unique_service_names == [
      "api",
      "worker",
      "billing",
      "search"
    ]
    error_message = "unique_service_names must remove duplicates with distinct()."
  }

  assert {
    condition     = output.unique_service_count == 4
    error_message = "unique_service_count must count the distinct service names."
  }

  assert {
    condition = output.nested_region_lists == [
      ["ap-southeast-2", "us-east-1"],
      ["ap-southeast-1", "us-east-1"],
      ["ap-southeast-2"]
    ]
    error_message = "nested_region_lists must read the values from service_regions."
  }

  assert {
    condition = output.unique_regions == [
      "ap-southeast-2",
      "us-east-1",
      "ap-southeast-1"
    ]
    error_message = "unique_regions must flatten nested_region_lists and remove duplicates."
  }

  assert {
    condition = output.service_region_labels == [
      "api:ap-southeast-2",
      "api:us-east-1",
      "billing:ap-southeast-1",
      "billing:us-east-1",
      "worker:ap-southeast-2"
    ]
    error_message = "service_region_labels must flatten service_regions into service:region labels."
  }
}
