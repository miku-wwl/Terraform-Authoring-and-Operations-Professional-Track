terraform {
  required_version = ">= 1.5.0"
}

variable "ami" {
  description = "AMI ID to use for the simulated EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the simulated EC2 instance."
  type        = string
}

variable "region" {
  description = "AWS region where the simulated EC2 instance would be deployed."
  type        = string
}

locals {
  instance_config = {
    ami = var.ami

    instance_type = var.instance_type

    region = var.region
  }
}

resource "terraform_data" "ec2_instance" {
  input = local.instance_config
}

output "instance_config" {
  description = "The simulated EC2 instance configuration after module variable resolution."
  value       = local.instance_config
}
