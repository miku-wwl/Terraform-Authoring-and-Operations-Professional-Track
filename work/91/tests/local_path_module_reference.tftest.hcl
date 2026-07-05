run "team_a_references_local_ec2_module" {
  command = plan

  assert {
    condition     = output.team_a_module_source == "../../modules/ec2"
    error_message = "team-a must record the local module source as ../../modules/ec2."
  }

  assert {
    condition = output.team_a_instance_record == {
      instance_name = "team-a-dev-app"
      ami_id        = "ami-0123456789abcdef0"
      instance_type = "t2.micro"
      team_name     = "team-a"
      environment   = "dev"
      tags = {
        owner       = "platform"
        cost_center = "cc-team-a"
        Name        = "team-a-dev-app"
        team        = "team-a"
        environment = "dev"
        module      = "local-ec2"
        managed_by  = "terraform"
      }
    }
    error_message = "team_a_instance_record must come from the shared local EC2 module with the expected inputs and merged tags."
  }

  assert {
    condition = output.lesson_summary == {
      topic              = "local path module reference"
      team_module_source = "./teams/team-a"
      ec2_module_source  = "../../modules/ec2"
      rule               = "local module source must begin with ./ or ../"
    }
    error_message = "lesson_summary must show the root team module source and the nested EC2 local path source."
  }
}
