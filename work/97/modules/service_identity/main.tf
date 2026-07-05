variable "service_name" {
  type        = string
  description = "Short service name passed from the root module."
}

variable "environment" {
  type        = string
  description = "Deployment environment passed from the root module."
}

variable "owner" {
  type        = string
  description = "Service owner passed from the root module."
}

locals {
  module_role       = "child-module"
  service_full_name = "${var.environment}-${var.service_name}"

  summary = {
    module_role       = local.module_role
    service_name      = var.service_name
    environment       = var.environment
    owner             = var.owner
    service_full_name = local.service_full_name
  }
}

output "module_role" {
  description = "Identifies this called module as a child module."
  value       = local.module_role
}

output "service_full_name" {
  description = "Environment-prefixed service name created inside the child module."
  value       = local.service_full_name
}

output "summary" {
  description = "Child module summary object."
  value       = local.summary
}
