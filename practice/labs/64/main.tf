terraform {
  required_version = ">= 1.5.0"
}

locals {
  nested      = [["api", "worker"], ["api", "billing"]]
  flat        = flatten(local.nested)
  unique_flat = distinct(local.flat)
}

resource "terraform_data" "lesson" {
  input = { topic = "flatten 与 distinct" }
}

output "flat" {
  value = local.flat
}

output "unique_flat" {
  value = local.unique_flat
}

output "unique_count" {
  value = length(local.unique_flat)
}


