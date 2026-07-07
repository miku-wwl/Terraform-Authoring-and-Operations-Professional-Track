terraform {
  required_version = ">= 1.5.0"
}

locals {
  ec2_instance_config = {
    name = "team-a-web"

    ami = "ami-0abcdef1234567890"

    instance_type = "t2.micro"

    region = "us-east-1"

    managed_by = "terraform-module"

    tags = {
      Environment = "dev"
      Owner       = "team-a"
      Module      = "ec2"
    }
  }

  supported_options = ["ami", "instance_type", "region", "tags"]
}

resource "terraform_data" "ec2_instance" {
  input = local.ec2_instance_config
}

output "instance_config" {
  description = "Simulated EC2 instance configuration managed by this local module."
  value       = terraform_data.ec2_instance.input
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
