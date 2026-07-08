output "metadata" {
  description = "Training metadata exposed by the EC2 module."
  value = {
    service_name  = terraform_data.instance_model.input.service_name
    instance_type = terraform_data.instance_model.input.instance_type
    tags          = terraform_data.instance_model.input.tags
  }
}
