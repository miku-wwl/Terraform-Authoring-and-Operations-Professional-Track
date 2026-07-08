terraform {
  required_version = ">= 1.5.0"
}

module "team_app" {
  source = "./modules/ec2"

  ami = "ami-0123456789abcdef0"

  instance_type = "t2.micro"

  region = "ap-south-1"
}

output "team_instance_config" {
  description = "The effective instance configuration returned by the EC2 module."
  value       = module.team_app.instance_config
}

output "team_instance_ami" {
  description = "The AMI value used by the EC2 module."
  value       = module.team_app.instance_config.ami
}

output "team_instance_type" {
  description = "The instance type used by the EC2 module."
  value       = module.team_app.instance_config.instance_type
}

output "team_region" {
  description = "The region value used by the EC2 module."
  value       = module.team_app.instance_config.region
}
