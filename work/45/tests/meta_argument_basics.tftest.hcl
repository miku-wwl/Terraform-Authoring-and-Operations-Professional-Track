run "aws_ec2_resource_behavior_is_modelled" {
  command = apply

  assert {
    condition     = contains(output.aws_ec2_behavior_model.created_instances, "web")
    error_message = "必须用 for_each 创建 web 这个模拟 EC2 实例。"
  }

  assert {
    condition     = lookup(output.aws_ec2_behavior_model.ami_by_instance, "web", "") == "ami-0123456789abcdef0"
    error_message = "AMI ID 应进入实例模型，并用于模拟 AWS EC2 的替换触发。"
  }

  assert {
    condition     = lookup(output.aws_ec2_behavior_model.instance_type_by_instance, "web", "") == "t3.micro"
    error_message = "instance_type 应作为模拟 EC2 的可调整配置。"
  }

  assert {
    condition     = contains(lookup(output.aws_ec2_behavior_model.force_new_keys, "web", []), "ami")
    error_message = "实验必须体现 AMI 属于会触发替换的 ForceNew 类字段。"
  }

  assert {
    condition     = contains(lookup(output.aws_ec2_behavior_model.update_in_place_keys, "web", []), "tags")
    error_message = "实验必须体现 tags 这类字段通常可原地更新。"
  }

  assert {
    condition     = lookup(output.aws_ec2_behavior_model.replacement_strategies, "web", "") == "create_before_destroy"
    error_message = "替换策略应记录为 create_before_destroy。"
  }

  assert {
    condition     = contains(output.aws_ec2_behavior_model.meta_arguments, "for_each") && contains(output.aws_ec2_behavior_model.meta_arguments, "lifecycle")
    error_message = "实验必须覆盖 for_each 和 lifecycle meta-argument。"
  }
}
