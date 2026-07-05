output "service_id" {
  description = "Stable service id built by the module."
  value       = local.service_id
}

output "service_summary" {
  description = "Summary string built from module input variables."
  value       = local.service_summary
}

output "module_source_style" {
  description = "Source style represented by this module."
  value       = local.module_source_style
}

output "module_contract_note" {
  description = "Human-readable note explaining this module's source style."
  value       = local.module_contract_note
}
