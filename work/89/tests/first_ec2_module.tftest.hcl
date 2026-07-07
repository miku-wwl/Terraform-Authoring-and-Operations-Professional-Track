run "first_ec2_module_is_created_and_called" {
  command = plan

  assert {
    condition = output.team_a_instance_config == {
      name          = "team-a-web"
      ami           = "ami-0abcdef1234567890"
      instance_type = "t2.micro"
      region        = "us-east-1"
      managed_by    = "terraform-module"
      tags = {
        Environment = "dev"
        Owner       = "team-a"
        Module      = "ec2"
      }
    }
    error_message = "team_a_instance_config must come from the local EC2 module and match the expected simulated EC2 configuration."
  }

  assert {
    condition     = output.team_a_module_metadata.module_name == "ec2"
    error_message = "The local module must expose module_metadata.module_name as ec2."
  }

  assert {
    condition     = output.team_a_module_metadata.module_path == "modules/ec2"
    error_message = "The local module must identify its path as modules/ec2."
  }

  assert {
    condition     = output.team_a_module_metadata.module_files == ["main.tf"]
    error_message = "This first module should remain minimal and only require modules/ec2/main.tf."
  }

  assert {
    condition     = output.team_a_supported_options == ["ami", "instance_type", "region", "tags"]
    error_message = "supported_options must include only the small option set needed by this internal module: ami, instance_type, region, and tags."
  }

  assert {
    condition = !contains(output.team_a_supported_options, "maintenance_options") && !contains(output.team_a_supported_options, "user_data_base64") && !contains(output.team_a_supported_options, "source_dest_check")
    error_message = "Do not turn this first internal module into a large public-style EC2 module. Keep unsupported advanced options out."
  }
}
