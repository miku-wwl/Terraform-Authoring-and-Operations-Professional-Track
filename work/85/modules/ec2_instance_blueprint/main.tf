variable "name" {
  type        = string
  description = "Simulated EC2 instance name."

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "name must not be empty."
  }
}

variable "ami_id" {
  type        = string
  description = "Simulated AMI ID."

  validation {
    condition     = can(regex("^ami-[0-9a-f]{17}$", var.ami_id))
    error_message = "ami_id must look like an AWS AMI ID, for example ami-0123456789abcdef0."
  }
}

variable "instance_type" {
  type        = string
  description = "Simulated EC2 instance type."

  validation {
    condition     = contains(["t2.nano", "t2.micro", "t3.micro", "t3.small"], var.instance_type)
    error_message = "instance_type must be one of the allowed training sizes."
  }
}

variable "enable_public_ip" {
  type        = bool
  description = "Whether the simulated instance should receive a public IP."
}

variable "tags" {
  type        = map(string)
  description = "Standard tags attached to the simulated EC2 instance."
}

locals {
  instance_config = {
    name             = var.name
    ami_id           = var.ami_id
    instance_type    = var.instance_type
    enable_public_ip = var.enable_public_ip
    tags             = var.tags
  }
}

resource "terraform_data" "ec2_blueprint" {
  input = local.instance_config
}

output "instance_config" {
  description = "Normalized simulated EC2 instance configuration."
  value       = terraform_data.ec2_blueprint.input
}
