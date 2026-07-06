run "local_modules_standardize_services" {
  command = plan

  assert {
    condition     = length(output.service_records) == 3
    error_message = "service_records must collect all three module service_record outputs."
  }

  assert {
    condition     = output.enabled_service_names == ["payments-api", "commerce-web"]
    error_message = "enabled_service_names must include only enabled module outputs in order."
  }

  assert {
    condition = output.all_port_labels == [
      "payments-api:8080",
      "payments-api:9090",
      "commerce-web:3000",
      "batch-worker:9000"
    ]
    error_message = "all_port_labels must flatten all service:port labels from module outputs."
  }

  assert {
    condition = keys(output.services_by_name) == [
      "batch-worker",
      "commerce-web",
      "payments-api"
    ]
    error_message = "services_by_name must be a map keyed by service_name."
  }

  assert {
    condition = (
      output.services_by_name["payments-api"].service_name == "payments-api" &&
      output.services_by_name["payments-api"].team_name == "payments" &&
      output.services_by_name["payments-api"].environment == "dev" &&
      output.services_by_name["payments-api"].owner == "platform" &&
      output.services_by_name["payments-api"].enabled == true &&
      length(output.services_by_name["payments-api"].ports) == 2 &&
      output.services_by_name["payments-api"].ports[0] == 8080 &&
      output.services_by_name["payments-api"].ports[1] == 9090 &&
      output.services_by_name["payments-api"].tags.managed_by == "terraform" &&
      output.services_by_name["payments-api"].tags.standard == "central-service-module" &&
      output.services_by_name["payments-api"].tags.service == "payments-api" &&
      output.services_by_name["payments-api"].tags.team == "payments" &&
      output.services_by_name["payments-api"].tags.environment == "dev" &&
      output.services_by_name["payments-api"].tags.owner == "platform" &&
      length(output.services_by_name["payments-api"].port_labels) == 2 &&
      output.services_by_name["payments-api"].port_labels[0] == "payments-api:8080" &&
      output.services_by_name["payments-api"].port_labels[1] == "payments-api:9090"
    )
    error_message = "payments-api service record must be standardized by the module."
  }

  assert {
    condition = output.services_by_name["commerce-web"].tags == {
      managed_by  = "terraform"
      standard    = "central-service-module"
      service     = "commerce-web"
      team        = "commerce"
      environment = "dev"
      owner       = "commerce"
    }
    error_message = "commerce-web tags must combine caller common tags and module standard tags."
  }

  assert {
    condition     = output.services_by_name["batch-worker"].enabled == false
    error_message = "batch-worker must remain disabled so enabled filtering can be verified."
  }

  assert {
    condition = output.lesson_summary == {
      topic          = "terraform modules and dry reuse"
      service_count  = 3
      enabled_count  = 2
      module_source  = "./modules/service_template"
      module_pattern = "standard template reused by multiple teams"
    }
    error_message = "lesson_summary must summarize the module reuse pattern."
  }
}
