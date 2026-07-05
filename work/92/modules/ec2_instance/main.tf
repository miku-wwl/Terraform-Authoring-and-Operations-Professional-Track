locals {
  # TODO 1: Replace this hard-coded AMI with var.ami_id.
  selected_ami_id = "ami-0123456789abcdef0"

  # TODO 2: Replace this hard-coded instance type with var.instance_type.
  selected_instance_type = "t2.micro"

  # TODO 3: Remove module-owned region from this module.
  # The caller's provider configuration should decide where AWS resources run.
  selected_region = "us-east-1"
}

resource "terraform_data" "ec2_plan" {
  input = {
    ami_id        = local.selected_ami_id
    instance_type = local.selected_instance_type
    instance_name = var.instance_name
    region        = local.selected_region
  }
}

output "ec2_config" {
  description = "Simulated EC2 config produced by this module."
  value       = terraform_data.ec2_plan.input
}
