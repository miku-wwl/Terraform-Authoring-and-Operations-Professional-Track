locals {
  selected_name = var.name

  selected_environment = var.environment

  selected_instance_type = var.instance_type

  selected_enable_hibernation = var.enable_hibernation

  selected_tags = var.tags

  selected_label = "${local.selected_name}:${local.selected_environment}:${local.selected_instance_type}"

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
