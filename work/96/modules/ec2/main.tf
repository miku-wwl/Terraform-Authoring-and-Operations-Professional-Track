terraform {
  required_version = ">= 1.5.0"
}

locals {
  instance_config = {
    id            = "i-0abc1234module96"
    name          = "team-web-96"
    ami           = "ami-0123456789abcdef0"
    instance_type = "t2.micro"
    region        = "us-east-1"
    private_ip    = "10.0.1.25"
    tags = {
      Environment = "dev"
      Owner       = "team-web"
      Module      = "ec2"
    }
  }
}

resource "terraform_data" "ec2_instance" {
  input = local.instance_config
}

output "instance_id" {
  description = "The simulated EC2 instance ID that callers can use for cross-resource configuration."

  value = terraform_data.ec2_instance.output.id
}

output "instance_config" {
  description = "The full simulated EC2 instance configuration returned by this module."
  value       = terraform_data.ec2_instance.output
}
