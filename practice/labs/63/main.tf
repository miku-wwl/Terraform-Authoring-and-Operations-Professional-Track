terraform {
  required_version = ">= 1.5.0"
}

locals {
  regions = ["local-a", "local-b"]
  apps    = ["api", "worker"]
  pairs   = flatten([for region in local.regions : [for app in local.apps : "${region}-${app}"]])
}

resource "terraform_data" "lesson" {
  input = { topic = "嵌套 for 表达式" }
}

output "pairs" {
  value = local.pairs
}

output "pair_count" {
  value = length(local.pairs)
}


