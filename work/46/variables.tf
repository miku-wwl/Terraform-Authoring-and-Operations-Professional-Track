variable "ami_id" {
  type        = string
  description = "LocalStack 中用于创建模拟 EC2 的 AMI ID。"
  default     = "ami-0123456789abcdef0"
}

variable "ami_rollout_generation" {
  type        = string
  description = "模拟 AMI rollout 批次；变化时应通过 replace_triggered_by 触发 EC2 替换。"
  default     = "rollout-1"
}

variable "instance_type" {
  type        = string
  description = "模拟 EC2 的 instance_type。"
  default     = "t3.micro"
}
