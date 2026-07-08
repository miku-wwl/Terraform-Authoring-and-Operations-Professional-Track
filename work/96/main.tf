terraform {
  required_version = ">= 1.5.0"
}

module "web_ec2" {
  source = "./modules/ec2"
}

locals {
  elastic_ip = {
    allocation_id = "eipalloc-096moduleoutput"
    public_ip     = "203.0.113.96"
    purpose       = "stable-public-ip-for-web"
  }
}

resource "terraform_data" "elastic_ip_association" {
  input = {
    allocation_id = local.elastic_ip.allocation_id
    public_ip     = local.elastic_ip.public_ip

    # TODO 2: Attach the Elastic IP to the instance ID exported by the EC2 module.
    # Hint: instance = module.web_ec2.instance_id
    instance = "TODO"
  }
}

output "module_instance_id" {
  description = "Instance ID exported by the EC2 child module."
  value       = module.web_ec2.instance_id
}

output "module_instance_config" {
  description = "Full instance config exported by the EC2 child module."
  value       = module.web_ec2.instance_config
}

output "elastic_ip_association" {
  description = "Simulated Elastic IP association using the module output."
  value       = terraform_data.elastic_ip_association.output
}

output "associated_instance_id" {
  description = "Instance ID used by the simulated Elastic IP association."
  value       = terraform_data.elastic_ip_association.output.instance
}

output "associated_public_ip" {
  description = "Public IP attached to the simulated instance."
  value       = terraform_data.elastic_ip_association.output.public_ip
}
