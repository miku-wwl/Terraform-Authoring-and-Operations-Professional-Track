terraform {
  required_version = ">= 1.5.0"

  cloud {
    # TODO 1: Replace this placeholder with the HCP Terraform organization used by the remote workspace.
    organization = "TODO"

    workspaces {
      # TODO 2: Replace this placeholder with the CLI-driven remote operation workspace name.
      name = "TODO"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  # TODO 3: Set the AWS region used by the remote run example.
  region = "TODO"
}

resource "aws_security_group" "allow_tls" {
  # TODO 4: Set the Security Group name used in the remote plan/apply example.
  name        = "TODO"
  description = "Security group used to demonstrate HCP Terraform CLI-driven workflow."

  ingress {
    description = "Allow HTTPS traffic for the demo rule."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic for the demo rule."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
