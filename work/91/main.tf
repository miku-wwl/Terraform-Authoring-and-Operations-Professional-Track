terraform {
  required_version = ">= 1.5.0"
}

module "team_a" {
  source = "./teams/team-a"
}

resource "terraform_data" "lesson" {
  input = {
    topic              = "local path module reference"
    team_module_source = "./teams/team-a"
    ec2_module_source  = module.team_a.module_source
    rule               = "local module source must begin with ./ or ../"
  }
}

output "team_a_module_source" {
  description = "The local path used by team-a to reference the EC2 module."
  value       = module.team_a.module_source
}

output "team_a_instance_record" {
  description = "Mock EC2 instance record returned by team-a's local module call."
  value       = module.team_a.instance_record
}

output "lesson_summary" {
  description = "Summary object for this local module path lesson."
  value       = terraform_data.lesson.input
}
