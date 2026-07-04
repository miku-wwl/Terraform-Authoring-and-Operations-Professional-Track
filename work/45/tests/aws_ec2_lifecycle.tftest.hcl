run "aws_ec2_lifecycle_meta_arguments" {
  command = apply

  assert {
    condition     = contains(keys(output.instance_ids), "web")
    error_message = "必须用 for_each 创建 web 这个模拟 EC2 实例。"
  }

  assert {
    condition     = lookup(output.instance_ami_ids, "web", "") == "ami-0123456789abcdef0"
    error_message = "web 实例必须使用 var.ami_id 指定的 AMI。"
  }

  assert {
    condition     = lookup(output.instance_types, "web", "") == "t3.micro"
    error_message = "web 实例必须使用 var.instance_type 指定的规格。"
  }

  assert {
    condition     = lookup(output.instance_names, "web", "") == "tf-lab-45-web"
    error_message = "web 实例必须保留 Name tag。"
  }

  assert {
    condition     = strcontains(output.resource_behavior_notes.lifecycle, "create_before_destroy")
    error_message = "实验必须覆盖 lifecycle.create_before_destroy。"
  }
}
