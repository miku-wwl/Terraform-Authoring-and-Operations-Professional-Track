output "service_record" {
  description = "Standardized service record produced by the service template module."
  value       = local.service_record
}

output "service_name" {
  description = "Service name passed into the module."
  value       = var.service_name
}

output "port_labels" {
  description = "Generated service:port labels."
  value       = local.port_labels
}
