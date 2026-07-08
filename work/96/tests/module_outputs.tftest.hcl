run "module_output_is_used_for_elastic_ip_association" {
  command = plan

  assert {
    condition     = can(regex("output\\s+\"instance_id\"\\s*\\{[\\s\\S]*value\\s*=\\s*terraform_data\\.ec2_instance\\.output\\.id", file("${path.module}/modules/ec2/main.tf")))
    error_message = "module_instance_id must be exported from modules/ec2 using terraform_data.ec2_instance.output.id."
  }

  assert {
    condition     = can(regex("output\\s+\"instance_config\"\\s*\\{[\\s\\S]*value\\s*=\\s*terraform_data\\.ec2_instance\\.output", file("${path.module}/modules/ec2/main.tf")))
    error_message = "module_instance_config.id must match the dedicated module_instance_id output."
  }

  assert {
    condition     = can(regex("allocation_id\\s*=\\s*local\\.elastic_ip\\.allocation_id", file("${path.module}/main.tf")))
    error_message = "elastic_ip_association must keep the simulated allocation_id."
  }

  assert {
    condition     = can(regex("public_ip\\s*=\\s*local\\.elastic_ip\\.public_ip", file("${path.module}/main.tf")))
    error_message = "associated_public_ip must come from the simulated Elastic IP configuration."
  }

  assert {
    condition     = can(regex("instance\\s*=\\s*module\\.web_ec2\\.instance_id", file("${path.module}/main.tf")))
    error_message = "The Elastic IP association must use module.web_ec2.instance_id instead of a hardcoded value."
  }

  assert {
    condition     = !can(regex("instance\\s*=\\s*\"TODO\"", file("${path.module}/main.tf")))
    error_message = "Replace the TODO placeholder in main.tf with module.web_ec2.instance_id."
  }
}
