terraform {
  required_version = ">= 1.5.0"
}

module "team_a_ec2" {
  source = "./modules/ec2_instance"

  ami_id        = "ami-team-a-ubuntu"
  instance_type = "t2.large"
  instance_name = "team-a-app"
}

locals {
  module_main_tf     = file("${path.module}/modules/ec2_instance/main.tf")
  module_versions_tf = file("${path.module}/modules/ec2_instance/versions.tf")

  module_main_has_region_literal = length(regexall("us-east-1|ap-south-1|region\\s*=", local.module_main_tf)) > 0
  module_versions_has_aws_source = length(regexall("source\\s*=\\s*\"hashicorp/aws\"", local.module_versions_tf)) > 0
  module_versions_has_aws_version = length(regexall("version\\s*=\\s*\"[^\"]*>=\\s*5\\.5[^\"]*\"", local.module_versions_tf)) > 0
}

resource "terraform_data" "lesson" {
  input = {
    topic = "custom module hardcoding and provider improvements"
    path  = "modules/ec2_instance"
  }
}

output "effective_module_config" {
  description = "The simulated EC2 configuration produced by the reusable module."
  value       = module.team_a_ec2.ec2_config
}

output "module_main_has_region_literal" {
  description = "Whether the module main.tf still contains a fixed region assignment or known region literal."
  value       = local.module_main_has_region_literal
}

output "module_versions_has_aws_required_provider" {
  description = "Whether versions.tf declares hashicorp/aws with a >= 5.5 version constraint."
  value       = local.module_versions_has_aws_source && local.module_versions_has_aws_version
}
