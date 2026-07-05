variable "ami_id" {
  description = "AMI ID supplied by the module caller."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type supplied by the module caller."
  type        = string
}

variable "instance_name" {
  description = "Name tag value supplied by the module caller."
  type        = string
}
