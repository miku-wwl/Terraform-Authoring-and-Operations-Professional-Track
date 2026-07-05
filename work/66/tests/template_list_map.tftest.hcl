run "template_renders_map_with_loop" {
  command = apply

  assert {
    condition = output.service_ports == {
      api     = 8080
      billing = 7070
      worker  = 9000
    }
    error_message = "service_ports must define api, billing, and worker ports."
  }

  assert {
    condition     = output.service_names == tolist(["api", "billing", "worker"])
    error_message = "service_names must be the sorted keys from service_ports."
  }

  assert {
    condition = output.rendered_services == <<-EOT
    services:
    - api: 8080
    - billing: 7070
    - worker: 9000
    EOT
    error_message = "rendered_services must render every service from the map."
  }

  assert {
    condition = output.rendered_lines == tolist([
      "services:",
      "- api: 8080",
      "- billing: 7070",
      "- worker: 9000"
    ])
    error_message = "rendered_lines must split the rendered template into lines."
  }

  assert {
    condition     = strcontains(output.rendered_file_path, "/output/services.txt") || strcontains(output.rendered_file_path, "\\output\\services.txt")
    error_message = "rendered_file_path must point to output/services.txt under the module directory."
  }
}
