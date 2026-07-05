variable "aws_region" {
  description = "AWS region selected by Team A."
  type        = string
  default     = "ap-south-1"
}

# TODO 4: Configure the AWS provider in the caller, using region = var.aws_region.

module "ec2" {
  source = "../../modules/ec2"

  name          = "team-a-demo"
  instance_type = "t3.micro"

  # TODO 5: Remove this region argument from the module call.
  # Region belongs to provider configuration in the caller.
  region = "ap-south-1"
}
