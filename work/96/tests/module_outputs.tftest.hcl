run "module_output_is_used_for_elastic_ip_association" {
  command = plan

  assert {
    condition     = output.module_instance_id == "i-0abc1234module96"
    error_message = "module_instance_id must be exported from modules/ec2 using terraform_data.ec2_instance.output.id."
  }

  assert {
    condition     = output.module_instance_config.id == output.module_instance_id
    error_message = "module_instance_config.id must match the dedicated module_instance_id output."
  }

  assert {
    condition     = output.elastic_ip_association.allocation_id == "eipalloc-096moduleoutput"
    error_message = "elastic_ip_association must keep the simulated allocation_id."
  }

  assert {
    condition     = output.associated_public_ip == "203.0.113.96"
    error_message = "associated_public_ip must come from the simulated Elastic IP configuration."
  }

  assert {
    condition     = output.associated_instance_id == output.module_instance_id
    error_message = "The Elastic IP association must use module.web_ec2.instance_id instead of a hardcoded value."
  }

  assert {
    condition     = output.associated_instance_id != "TODO"
    error_message = "Replace the TODO placeholder in main.tf with module.web_ec2.instance_id."
  }
}
