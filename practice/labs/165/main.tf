locals {
  ec2_data = csvdecode(file("ec2.csv"))
}

output "instance_ids" {
  value = [for row in local.ec2_data : row.instance_id]
}

output "instance_summary" {
  value = {
    for row in local.ec2_data : row.name => {
      instance_id   = row.instance_id
      instance_type = row.instance_type
      team_name     = row.team_name
    }
  }
}
