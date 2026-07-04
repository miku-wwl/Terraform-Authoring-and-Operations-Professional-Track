resource "terraform_data" "ami_rollout" {
  input = {
    generation = var.ami_rollout_generation
  }
}

resource "aws_instance" "web" {
  # TODO 1：用 for_each 管理 var.desired_ec2_instances。
  # 提示：新增 map key 表示 create，删除 map key 表示 destroy。
  for_each = {}

  # TODO 2：让实例使用 var.ami_id。
  # 提示：真实 aws_instance 修改 ami 通常会触发 replace。
  ami = "TODO-ami-id"

  # TODO 3：让实例规格来自 var.instance_type。
  # 提示：instance_type 用来观察普通配置更新与替换行为的差异。
  instance_type = "TODO-instance-type"

  tags = merge(each.value.tags, {
    Name = each.value.name
  })

  lifecycle {
    # TODO 4：替换 EC2 时先创建新实例，再销毁旧实例。
    # 提示：真实 AWS 中使用前要确认名称、IP、配额等是否允许新旧资源同时存在。
    create_before_destroy = false

    # TODO 5：把 AMI rollout 资源作为替换触发来源。
    # 提示：使用 [terraform_data.ami_rollout]；之后改变 ami_rollout_generation 应触发替换计划。
    replace_triggered_by = []
  }
}
