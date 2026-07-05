locals {
  standard_tags = merge(var.extra_tags, {
    Name        = var.instance_name
    team        = var.team_name
    environment = var.environment
    module      = "local-ec2"
    managed_by  = "terraform"
  })

  instance_record = {
    instance_name = var.instance_name
    ami_id        = var.ami_id
    instance_type = var.instance_type
    team_name     = var.team_name
    environment   = var.environment
    tags          = local.standard_tags
  }
}

resource "terraform_data" "mock_ec2" {
  input = local.instance_record
}
