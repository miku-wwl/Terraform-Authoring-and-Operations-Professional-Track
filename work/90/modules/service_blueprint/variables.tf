variable "service_name" {
  type        = string
  description = "Name of the service represented by this module."
}

variable "environment" {
  type        = string
  description = "Deployment environment for the service."
}

variable "owner" {
  type        = string
  description = "Team that owns the service."
}
