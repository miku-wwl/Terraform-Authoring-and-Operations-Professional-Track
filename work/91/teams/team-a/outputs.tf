output "module_source" {
  description = "Local path used to reference the shared EC2 module."
  value       = local.ec2_module_source
}

output "instance_record" {
  description = "Mock EC2 instance record returned by the shared local module."
  value       = module.team_a_ec2.instance_record
}
