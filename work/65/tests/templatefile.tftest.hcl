run "templatefile_expressions_are_correct" {
  command = apply

  assert {
    condition = output.service_config == {
      name        = "payments"
      environment = "dev"
      owner       = "platform"
    }
    error_message = "service_config must contain the values passed into templatefile()."
  }

  assert {
    condition = output.rendered_service_config == <<-EOT
    service=payments
    environment=dev
    owner=platform
    EOT
    error_message = "rendered_service_config must render template.tftpl with service_config."
  }

  assert {
    condition     = strcontains(output.rendered_file_path, "/output/service.txt") || strcontains(output.rendered_file_path, "\\output\\service.txt")
    error_message = "rendered_file_path must point to output/service.txt under the module directory."
  }

  assert {
    condition     = output.rendered_preview == "service=payments"
    error_message = "rendered_preview must be the first rendered template line."
  }
}
