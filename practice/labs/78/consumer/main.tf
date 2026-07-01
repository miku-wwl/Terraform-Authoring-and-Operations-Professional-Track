terraform {
  required_version = ">= 1.12.0"
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket                      = "tf-pro-state-localstack"
    key                         = "labs/78/network/terraform.tfstate"
    region                      = "us-east-1"
    access_key                  = "test"
    secret_key                  = "test"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
    endpoints = {
      s3       = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
    }
  }
}

resource "terraform_data" "security_rule" {
  input = {
    lab          = "78"
    allowed_cidr = data.terraform_remote_state.network.outputs.public_cidr
    source_owner = data.terraform_remote_state.network.outputs.network_owner
    managed_by   = "security-team"
  }
}

output "allowed_cidr_from_remote_state" {
  value = terraform_data.security_rule.output.allowed_cidr
}
