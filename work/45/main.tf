terraform {
  required_version = ">= 1.5.0"
}

variable "ami_id" {
  type        = string
  description = "模拟 AWS EC2 使用的 AMI ID；真实 aws_instance 中 AMI 变化通常会触发替换。"
  default     = "ami-0123456789abcdef0"
}

variable "instance_type" {
  type        = string
  description = "模拟 AWS EC2 instance_type；用于表示可调整的运行配置。"
  default     = "t3.micro"
}

locals {
  desired_ec2_instances = {
    web = {
      instance_type = var.instance_type
      tags = {
        Name        = "web"
        Environment = "dev"
      }
    }
  }

  # TODO 1：把 AWS EC2 的 AMI 替换信号接到 var.ami_id。
  # 提示：真实 aws_instance 修改 ami 通常不是原地 update，而是 replace。
  ec2_ami_force_new_marker = "TODO-ami-id"

  # TODO 2：记录替换策略名称，用来和 lifecycle.create_before_destroy 对齐。
  # 提示：这里应填写 create_before_destroy。
  replacement_strategy = "TODO-replacement-strategy"
}

resource "terraform_data" "ami_rollout" {
  input = {
    ami_id = local.ec2_ami_force_new_marker
  }
}

resource "terraform_data" "ec2_instance_model" {
  # TODO 3：用 for_each 根据 desired_ec2_instances 创建模拟 EC2 实例。
  # 提示：新增 map key 表示 create，删除 map key 表示 destroy。
  for_each = {}

  input = {
    aws_resource_type    = "aws_instance"
    name                 = each.key
    ami                  = local.ec2_ami_force_new_marker
    instance_type        = each.value.instance_type
    tags                 = each.value.tags
    update_in_place_keys = ["instance_type", "tags"]
    force_new_keys       = ["ami"]
    replacement_strategy = local.replacement_strategy
  }

  lifecycle {
    # TODO 4：模拟 EC2 替换时先创建新实例，再销毁旧实例。
    # 提示：真实 AWS 中使用前要确认名称、IP、配额等是否允许新旧资源同时存在。
    create_before_destroy = false

    # TODO 5：把 AMI rollout 资源作为替换触发来源。
    # 提示：使用 [terraform_data.ami_rollout]。
    replace_triggered_by = []
  }
}

output "aws_ec2_behavior_model" {
  value = {
    created_instances = keys(terraform_data.ec2_instance_model)
    ami_by_instance = {
      for name, instance in terraform_data.ec2_instance_model : name => instance.output.ami
    }
    instance_type_by_instance = {
      for name, instance in terraform_data.ec2_instance_model : name => instance.output.instance_type
    }
    update_in_place_keys = {
      for name, instance in terraform_data.ec2_instance_model : name => instance.output.update_in_place_keys
    }
    force_new_keys = {
      for name, instance in terraform_data.ec2_instance_model : name => instance.output.force_new_keys
    }
    replacement_strategies = {
      for name, instance in terraform_data.ec2_instance_model : name => instance.output.replacement_strategy
    }
    meta_arguments = ["for_each", "lifecycle", "create_before_destroy", "replace_triggered_by"]
  }
}
