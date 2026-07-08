variable "aws_region" {
  description = "AWS region selected by Team A."
  type        = string
  default     = "ap-south-1"
}

provider "aws" {
  region = var.aws_region
}

module "ec2" {
  source = "../../modules/ec2"

  name          = "team-a-demo"
  instance_type = "t3.micro"

  # Region belongs to provider configuration in the caller.
}
