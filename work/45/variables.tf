variable "ami_id" {
  type        = string
  description = "LocalStack 中用于创建模拟 EC2 的 AMI ID。"
  default     = "ami-0123456789abcdef0"
}

variable "ami_rollout_generation" {
  type        = string
  description = "模拟 AMI rollout 批次；变化时通过 replace_triggered_by 触发 EC2 替换。"
  default     = "rollout-1"
}

variable "instance_type" {
  type        = string
  description = "模拟 EC2 的 instance_type；真实 AWS 中这类运行配置通常可调整。"
  default     = "t3.micro"
}

variable "desired_ec2_instances" {
  type = map(object({
    name = string
    tags = map(string)
  }))
  description = "要由 for_each 管理的模拟 EC2 实例集合。新增 key 表示 create，删除 key 表示 destroy。"
  default = {
    web = {
      name = "tf-lab-45-web"
      tags = {
        Project     = "tf-lab-45"
        Environment = "dev"
      }
    }
  }
}
