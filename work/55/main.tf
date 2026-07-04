terraform {
  required_version = ">= 1.5.0"
}

locals {
  user_names = ["user-01", "user-02", "user-03"]
}

# count is a resource meta-argument. When count creates multiple instances,
# Terraform exposes count.index inside this block as the current zero-based index.
resource "terraform_data" "user" {
  count = length(local.user_names)

  input = {
    name = local.user_names[count.index]

    index = count.index

    label = "user-${count.index}-${local.user_names[count.index]}"
  }
}

locals {
  created_user_names = [for user in terraform_data.user : user.output.name]

  created_user_labels = [for user in terraform_data.user : user.output.label]
}

output "user_names" {
  description = "Input list of user names."
  value       = local.user_names
}

output "user_count" {
  description = "Number of user names used by count."
  value       = length(local.user_names)
}

output "resource_count" {
  description = "Number of terraform_data.user instances created with count."
  value       = length(terraform_data.user)
}

output "first_user_name" {
  description = "Name read from the first count-created resource instance."
  value       = terraform_data.user[0].output.name
}

output "second_user_index" {
  description = "Index read from the second count-created resource instance."
  value       = terraform_data.user[1].output.index
}

output "created_user_names" {
  description = "Names collected from all count-created resource instances."
  value       = local.created_user_names
}

output "created_user_labels" {
  description = "Labels collected from all count-created resource instances."
  value       = local.created_user_labels
}
