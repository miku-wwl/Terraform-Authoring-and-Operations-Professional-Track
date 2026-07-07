locals {
  selected_ami_id = var.ami_id

  selected_instance_type = var.instance_type
}

resource "terraform_data" "ec2_plan" {
  input = {
    ami_id        = local.selected_ami_id
    instance_type = local.selected_instance_type
    instance_name = var.instance_name
  }
}

output "ec2_config" {
  description = "Simulated EC2 config produced by this module."
  value       = terraform_data.ec2_plan.input
}
