locals {
  # TODO 1: Record the same local module source path used below.
  # Hint: from teams/team-a, go up twice and then into modules/ec2.
  ec2_module_source = "../../modules/TODO_REPLACE"

  # TODO 3: Add team common tags.
  # Hint: owner = "platform" and cost_center = "cc-team-a".
  team_tags = {
    owner       = ""
    cost_center = ""
  }
}

module "team_a_ec2" {
  # TODO 2: Replace this with the correct local module source path.
  # Hint: source = "../../modules/ec2".
  source = "../../modules/TODO_REPLACE"

  # TODO 4: Set instance_name to "team-a-dev-app".
  instance_name = ""

  # TODO 5: Set ami_id to "ami-0123456789abcdef0".
  ami_id = ""

  instance_type = "t2.micro"
  team_name     = "team-a"
  environment   = "dev"
  extra_tags    = local.team_tags
}
