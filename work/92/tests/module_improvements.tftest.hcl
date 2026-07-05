run "custom_module_hardcoding_improvements_are_correct" {
  command = plan

  assert {
    condition     = output.effective_module_config.ami_id == "ami-team-a-ubuntu"
    error_message = "The module must use var.ami_id instead of a hard-coded AMI."
  }

  assert {
    condition     = output.effective_module_config.instance_type == "t2.large"
    error_message = "The module must use var.instance_type instead of a hard-coded instance type."
  }

  assert {
    condition     = output.effective_module_config.instance_name == "team-a-app"
    error_message = "The module should still preserve the caller supplied instance_name."
  }

  assert {
    condition     = !contains(keys(output.effective_module_config), "region")
    error_message = "The module output must not include a region field; region belongs to caller/provider configuration."
  }

  assert {
    condition     = output.module_main_has_region_literal == false
    error_message = "modules/ec2_instance/main.tf must not keep region assignments or fixed region literals like us-east-1/ap-south-1."
  }

  assert {
    condition     = output.module_versions_has_aws_required_provider == true
    error_message = "modules/ec2_instance/versions.tf must declare hashicorp/aws with version constraint >= 5.5."
  }
}
