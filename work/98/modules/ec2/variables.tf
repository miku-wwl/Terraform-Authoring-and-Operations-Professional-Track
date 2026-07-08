variable "service_name" {
  description = "Logical service name represented by this module."
  type        = string
}

variable "instance_type" {
  description = "Mock EC2 instance type used for training."
  type        = string
}

variable "tags" {
  description = "Tags that would be applied to the instance in a real module."
  type        = map(string)
  default     = {}
}
