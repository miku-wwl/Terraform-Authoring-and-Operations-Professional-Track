terraform {
  required_version = ">= 1.6.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

variable "firewall_name" {
  type        = string
  description = "Logical firewall name used by this lab."
  default     = "demo-firewall"

  validation {
    condition     = length(trimspace(var.firewall_name)) > 0
    error_message = "firewall_name must not be empty."
  }
}

variable "environment" {
  type        = string
  description = "Environment label used to build the resource label."
  default     = "prod"

  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of dev, test, or prod."
  }
}

variable "region_label" {
  type        = string
  description = "Region-like label used to simulate a provider region choice."
  default     = "us-east-1"

  validation {
    condition     = length(trimspace(var.region_label)) > 0
    error_message = "region_label must not be empty."
  }
}

locals {
  resource_label = "${var.environment}:${var.region_label}:${var.firewall_name}"
  marker_path    = "${path.module}/.terraform-test-${var.environment}-${var.firewall_name}.txt"
}

resource "local_file" "test_marker" {
  filename = local.marker_path
  content  = local.resource_label
}

output "firewall_name" {
  description = "Firewall name after variable precedence is applied."
  value       = var.firewall_name
}

output "environment" {
  description = "Environment after variable precedence is applied."
  value       = var.environment
}

output "region_label" {
  description = "Region label after variable precedence is applied."
  value       = var.region_label
}

output "resource_label" {
  description = "Combined label built from environment, region_label, and firewall_name."
  value       = local.resource_label
}

output "marker_path" {
  description = "Path that the local provider resource would manage during apply."
  value       = local.marker_path
}
