run "standard_module_structure_is_detected" {
  command = plan

  assert {
    condition     = length(output.standard_required_files) == 4
    error_message = "standard_required_files must contain the four minimal recommended module files."
  }

  assert {
    condition = alltrue([
      contains(output.standard_required_files, "README.md"),
      contains(output.standard_required_files, "main.tf"),
      contains(output.standard_required_files, "variables.tf"),
      contains(output.standard_required_files, "outputs.tf")
    ])
    error_message = "standard_required_files must include README.md, main.tf, variables.tf, and outputs.tf."
  }

  assert {
    condition = alltrue([
      contains(output.ec2_module_files, "README.md"),
      contains(output.ec2_module_files, "main.tf"),
      contains(output.ec2_module_files, "variables.tf"),
      contains(output.ec2_module_files, "outputs.tf"),
      contains(output.ec2_module_files, "versions.tf")
    ])
    error_message = "ec2_module_files must be discovered from modules/ec2 and include the standard files plus versions.tf."
  }

  assert {
    condition     = length(output.missing_required_files) == 0
    error_message = "missing_required_files must be empty when modules/ec2 follows the minimal standard structure."
  }

  assert {
    condition     = output.architecture_service_count == 8
    error_message = "architecture_service_count must count all services from data/module_architecture.json."
  }

  assert {
    condition = output.module_boundaries == tolist([
      "compute",
      "database",
      "dns",
      "iam",
      "networking",
      "security",
      "storage"
    ])
    error_message = "module_boundaries must be a sorted unique list inferred from the architecture services."
  }

  assert {
    condition = jsonencode(output.module_catalog) == jsonencode({
      compute    = ["ec2"]
      database   = ["database"]
      dns        = ["route53"]
      iam        = ["iam"]
      networking = ["vpc", "load_balancer"]
      security   = ["firewall"]
      storage    = ["s3"]
    })
    error_message = "module_catalog must group service names by module boundary instead of creating one monolithic module."
  }

  assert {
    condition     = output.ec2_module_metadata.service_name == "ec2" && output.ec2_module_metadata.instance_type == "t3.micro"
    error_message = "The root module must call the local EC2 module and expose its metadata output."
  }
}
