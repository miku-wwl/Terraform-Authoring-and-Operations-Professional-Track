terraform {
  required_version = ">= 1.5.0"
}

locals {
  ec2_instance_config = {
    # TODO 1: Set the simulated instance name to team-a-web.
    name = "TODO"

    # TODO 2: Set the AMI to ami-0abcdef1234567890.
    ami = "TODO"

    # TODO 3: Set the instance type to t2.micro.
    instance_type = "TODO"

    # TODO 4: Set the region to us-east-1.
    region = "TODO"

    # TODO 5: Mark this configuration as managed by terraform-module.
    managed_by = "TODO"

    tags = {
      Environment = "dev"
      Owner       = "team-a"
      Module      = "ec2"
    }
  }

  # TODO 6: Keep this first internal module small.
  # Hint: supported_options should be ["ami", "instance_type", "region", "tags"].
  supported_options = []
}

resource "terraform_data" "ec2_instance" {
  input = local.ec2_instance_config
}

output "instance_config" {
  description = "Simulated EC2 instance configuration managed by this local module."
  value       = terraform_data.ec2_instance.output
}

output "module_metadata" {
  description = "Metadata for the small internal EC2 module."
  value = {
    module_name       = "ec2"
    module_path       = "modules/ec2"
    module_files      = ["main.tf"]
    module_style      = "small-internal-module"
    supported_options = local.supported_options
  }
}
