terraform {
  required_version = ">= 1.5.0"
}

# TODO 7: Call the local EC2 module from ./modules/ec2.
# Hint:
# module "team_a_ec2" {
#   source = "./modules/ec2"
# }

output "team_a_instance_config" {
  description = "The simulated EC2 instance configuration returned by the local EC2 module."
  value       = module.team_a_ec2.instance_config
}

output "team_a_module_metadata" {
  description = "Metadata showing this is a small internal EC2 module."
  value       = module.team_a_ec2.module_metadata
}

output "team_a_supported_options" {
  description = "The small set of EC2 options supported by this first internal module."
  value       = module.team_a_ec2.module_metadata.supported_options
}
