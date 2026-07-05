variable "name" {
  description = "Logical name requested by the module caller."
  type        = string
  default     = "hardcoded-instance"
}

variable "environment" {
  description = "Deployment environment requested by the module caller."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "instance_type" {
  description = "Instance type requested by the module caller."
  type        = string
  default     = "t2.micro"
}

variable "enable_hibernation" {
  description = "Whether hibernation should be enabled for the modeled instance."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags requested by the module caller."
  type        = map(string)
  default     = {}
}
