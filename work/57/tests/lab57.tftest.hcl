run "for_each_expressions_are_correct" {
  command = apply

  assert {
    condition = output.service_files == {
      api    = "api service"
      worker = "worker service"
      web    = "web service"
    }
    error_message = "service_files must be a map containing api, worker, and web."
  }

  assert {
    condition     = output.service_count == 3
    error_message = "service_count must be calculated from local.service_files."
  }

  assert {
    condition     = output.resource_count == 3
    error_message = "terraform_data.service must create one instance per map entry with for_each."
  }

  assert {
    condition     = output.service_keys == ["api", "web", "worker"]
    error_message = "service_keys must be calculated with keys(local.service_files)."
  }

  assert {
    condition     = output.api_content == "api service"
    error_message = "api_content must come from terraform_data.service[\"api\"].output.content."
  }

  assert {
    condition     = output.worker_name == "worker"
    error_message = "worker_name must come from terraform_data.service[\"worker\"].output.name."
  }

  assert {
    condition     = output.service_contents == ["api service", "web service", "worker service"]
    error_message = "service_contents must collect content values from all for_each-created instances."
  }

  assert {
    condition = output.service_labels_by_name == {
      api    = "api:api service"
      worker = "worker:worker service"
      web    = "web:web service"
    }
    error_message = "service_labels_by_name must collect labels keyed by service name."
  }
}
