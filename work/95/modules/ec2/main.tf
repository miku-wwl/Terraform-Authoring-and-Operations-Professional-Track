terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5"
    }
  }
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
