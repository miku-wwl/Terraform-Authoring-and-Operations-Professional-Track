terraform {
  required_version = ">= 1.5.0"
}

data "terraform_remote_state" "lab73" {
  backend = "s3"

  config = {
    bucket                      = "tfstate-lab73"
    key                         = "lab73/terraform.tfstate"
    region                      = "us-east-1"
    endpoint                    = "http://localhost:4566"
    access_key                  = "test"
    secret_key                  = "test"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

output "remote_application_bucket_name" {
  description = "Application bucket name read from the lab73 remote state file."
  value       = data.terraform_remote_state.lab73.outputs.application_bucket_name
}

output "remote_backend_summary" {
  description = "Backend lesson summary read from the lab73 remote state file."
  value       = data.terraform_remote_state.lab73.outputs.backend_lesson_summary
}
