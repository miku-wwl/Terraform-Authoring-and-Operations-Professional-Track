terraform {
  required_version = ">= 1.12.0"
}

resource "terraform_data" "network" {
  input = {
    lab         = "79"
    public_cidr = "203.0.113.79/32"
    owner       = "network-team"
  }
}

output "public_cidr" {
  value = terraform_data.network.output.public_cidr
}

output "network_owner" {
  value = terraform_data.network.output.owner
}
