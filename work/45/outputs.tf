output "instance_ids" {
  description = "LocalStack 中由 Terraform 管理的模拟 EC2 实例 ID。"
  value = {
    for name, instance in aws_instance.web : name => instance.id
  }
}

output "instance_ami_ids" {
  description = "每个模拟 EC2 实例使用的 AMI ID。"
  value = {
    for name, instance in aws_instance.web : name => instance.ami
  }
}

output "instance_types" {
  description = "每个模拟 EC2 实例的 instance_type。"
  value = {
    for name, instance in aws_instance.web : name => instance.instance_type
  }
}

output "instance_names" {
  description = "每个模拟 EC2 实例的 Name tag。"
  value = {
    for name, instance in aws_instance.web : name => instance.tags["Name"]
  }
}

output "resource_behavior_notes" {
  description = "本实验中 AWS EC2 行为与 Terraform meta-argument 的对应关系。"
  value = {
    create_destroy = "for_each controls which EC2 instances exist"
    update         = "instance_type and tags represent in-place updates"
    replace        = "ami changes represent replacement"
    lifecycle      = "create_before_destroy controls replacement order"
  }
}
