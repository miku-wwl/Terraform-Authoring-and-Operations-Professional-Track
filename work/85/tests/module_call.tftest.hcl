run "ec2_module_call_is_correct" {
  command = plan

  assert {
    condition     = output.ec2_instance_config == module.ec2_instance.instance_config
    error_message = "ec2_instance_config must expose module.ec2_instance.instance_config instead of a hand-built placeholder."
  }

  assert {
    condition     = output.ec2_instance_config.name == "training-web-01"
    error_message = "The EC2 blueprint name must be training-web-01."
  }

  assert {
    condition     = output.ec2_instance_config.ami_id == "ami-0123456789abcdef0"
    error_message = "The EC2 blueprint AMI ID must be ami-0123456789abcdef0."
  }

  assert {
    condition     = output.ec2_instance_config.instance_type == "t3.micro"
    error_message = "The EC2 blueprint instance_type must be t3.micro."
  }

  assert {
    condition     = output.ec2_instance_config.enable_public_ip == false
    error_message = "The EC2 blueprint must disable public IP assignment."
  }

  assert {
    condition = (
      length(keys(output.ec2_instance_config.tags)) == 3 &&
      output.ec2_instance_config.tags.Environment == "dev" &&
      output.ec2_instance_config.tags.Owner == "platform" &&
      output.ec2_instance_config.tags.ManagedBy == "terraform"
    )
    error_message = "The EC2 blueprint tags must include Environment, Owner, and ManagedBy with the expected values."
  }
}
