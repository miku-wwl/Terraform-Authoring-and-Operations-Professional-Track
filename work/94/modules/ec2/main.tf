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
    # TODO 1: Replace this hardcoded AMI with var.ami.
    ami = "ami-hardcoded-do-not-use"

    # TODO 2: Replace this hardcoded instance type with var.instance_type.
    instance_type = "t2.nano"

    # TODO 3: Replace this hardcoded region with var.region.
    region = "us-west-2"
  }
}

resource "terraform_data" "ec2_instance" {
  input = local.instance_config
}

output "instance_config" {
  description = "The simulated EC2 instance configuration after module variable resolution."
  value       = terraform_data.ec2_instance.output
}
