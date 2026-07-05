# TODO 1: Remove this provider block from the child module.
# Provider configuration such as region should live in the caller, not inside a reusable module.
provider "aws" {
  region = var.region
}

# TODO 2: Add a terraform block with required_providers.aws here.
# Required shape:
# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = ">= 5.5"
#     }
#   }
# }

# TODO 3: Remove this region variable after the provider block is removed.
variable "region" {
  description = "AWS region used by the module. This should move to the caller provider block."
  type        = string
  default     = "ap-south-1"
}

variable "name" {
  description = "Name tag for the EC2 instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

# This is intentionally simple training code. The root lab does not call this module,
# so the exercise focuses on module/provider structure rather than real AWS creation.
resource "aws_instance" "this" {
  ami           = "ami-1234567890abcdef0"
  instance_type = var.instance_type

  tags = {
    Name = var.name
  }
}

output "instance_id" {
  description = "ID of the EC2 instance created by this module."
  value       = aws_instance.this.id
}
