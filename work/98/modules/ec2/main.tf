resource "terraform_data" "instance_model" {
  input = {
    service_name  = var.service_name
    instance_type = var.instance_type
    tags          = var.tags
  }
}
