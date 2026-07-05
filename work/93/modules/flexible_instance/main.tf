locals {
  # TODO 1: Replace the hardcoded name with var.name.
  selected_name = "hardcoded-instance"

  # TODO 2: Replace the hardcoded environment with var.environment.
  selected_environment = "dev"

  # TODO 3: Replace the hardcoded instance type with var.instance_type.
  selected_instance_type = "t2.micro"

  # TODO 4: Replace the hardcoded hibernation flag with var.enable_hibernation.
  selected_enable_hibernation = false

  # TODO 5: Replace the hardcoded empty map with var.tags.
  selected_tags = {}

  # TODO 6: Build this label from the selected variable-backed values.
  # Expected format: "name:environment:instance_type".
  selected_label = "hardcoded-instance:dev:t2.micro"

  profile = {
    name               = local.selected_name
    environment        = local.selected_environment
    instance_type      = local.selected_instance_type
    enable_hibernation = local.selected_enable_hibernation
    tags               = local.selected_tags
    label              = local.selected_label
  }
}

resource "terraform_data" "profile" {
  input = local.profile
}
