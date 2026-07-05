run "module_variables_are_overridden_by_caller" {
  command = plan

  assert {
    condition     = output.team_instance_ami == "ami-0123456789abcdef0"
    error_message = "team_instance_ami must come from the ami value passed by the root module."
  }

  assert {
    condition     = output.team_instance_type == "t2.micro"
    error_message = "team_instance_type must come from the instance_type value passed by the root module."
  }

  assert {
    condition     = output.team_region == "ap-south-1"
    error_message = "team_region must come from the region value passed by the root module."
  }

  assert {
    condition = output.team_instance_config == {
      ami           = "ami-0123456789abcdef0"
      instance_type = "t2.micro"
      region        = "ap-south-1"
    }
    error_message = "team_instance_config must contain the effective values provided by the module caller."
  }

  assert {
    condition     = output.team_instance_ami != "ami-hardcoded-do-not-use" && output.team_instance_type != "t2.nano" && output.team_region != "us-west-2"
    error_message = "The module must not keep its original hardcoded fallback values. Replace them with var.ami, var.instance_type, and var.region."
  }
}
