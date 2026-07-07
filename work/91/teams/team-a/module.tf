locals {
  ec2_module_source = "../../modules/ec2"

  team_tags = {
    owner       = "platform"
    cost_center = "cc-team-a"
  }
}

module "team_a_ec2" {
  source = "../../modules/ec2"

  instance_name = "team-a-dev-app"

  ami_id = "ami-0123456789abcdef0"

  instance_type = "t2.micro"
  team_name     = "team-a"
  environment   = "dev"
  extra_tags    = local.team_tags
}
