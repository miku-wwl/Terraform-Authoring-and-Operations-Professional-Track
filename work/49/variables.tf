variable "ami_id" {
  type        = string
  description = "LocalStack 中用于创建模拟 EC2 的 AMI ID。"
  default     = "ami-0123456789abcdef0"
}

variable "instance_type" {
  type        = string
  description = "模拟 EC2 的 instance_type。"
  default     = "t3.micro"
}
