locals {
  all_data = csvdecode(file("ec2.csv"))
}

output "list_ami" {
  value = [for row in local.all_data : row.ami_id]
}

output "unique_team_names" {
  value = toset([for row in local.all_data : row.team_name])
}

output "region_list_of_lists" {
  value = [[for row in local.all_data : row.region][0], [for row in local.all_data : row.region][1]]
}

output "nano_regions" {
  value = [[for row in local.all_data : row.region if row.instance_type == "nano"]]
}

output "map_of_maps" {
  value = {
    for row in local.all_data : "${row.instance_type}_${row.region}_${row.team_name}" => {
      ami_id        = row.ami_id
      instance_type = row.instance_type
      region        = row.region
      team_name     = row.team_name
    }
  }
}
