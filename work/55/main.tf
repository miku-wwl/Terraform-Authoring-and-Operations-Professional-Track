terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1: Define three user names for count-based resources.
  # Hint: use ["user-01", "user-02", "user-03"].
  user_names = []
}

resource "terraform_data" "user" {
  # TODO 2: Create one terraform_data instance per user name.
  # Hint: use count = length(local.user_names).
  count = 0

  input = {
    # TODO 3: Read the matching user name by count index.
    # Hint: use local.user_names[count.index].
    name = "TODO-name"

    # TODO 4: Store the zero-based resource index.
    # Hint: use count.index.
    index = 0

    # TODO 5: Build a stable label from the count index and user name.
    # Hint: use "user-${count.index}-${local.user_names[count.index]}".
    label = "TODO-label"
  }
}

locals {
  # TODO 6: Collect names back from all count-created resource instances.
  # Hint: use [for user in terraform_data.user : user.output.name].
  created_user_names = []

  # TODO 7: Collect labels back from all count-created resource instances.
  # Hint: use [for user in terraform_data.user : user.output.label].
  created_user_labels = []
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
