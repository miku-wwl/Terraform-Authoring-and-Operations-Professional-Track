locals {
  ec2_data = csvdecode(file("ec2.csv"))
}

output "instance_specs" {
  value = local.ec2_data
}

output "instance_count" {
  value = length(local.ec2_data)
}
