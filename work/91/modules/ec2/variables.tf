variable "instance_name" {
  description = "Name of the mock EC2 instance requested by the team."
  type        = string
}

variable "ami_id" {
  description = "AMI ID selected by the calling team."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type selected by the calling team."
  type        = string
}

variable "team_name" {
  description = "Team that owns the instance."
  type        = string
}

variable "environment" {
  description = "Deployment environment, such as dev, test, or prod."
  type        = string
}

variable "extra_tags" {
  description = "Additional tags supplied by the calling team."
  type        = map(string)
  default     = {}
}
