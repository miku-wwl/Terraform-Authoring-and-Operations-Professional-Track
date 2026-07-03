terraform {
  required_version = ">= 1.5.0"
}

locals {
  regions = ["local-a", "local-b"]
  # TODO 1：在 apps 列表中添加 "worker"，使笛卡尔积生成 4 对 (2×2)。
  # 提示：嵌套 for 生成 region-app 组合，2 regions × 2 apps = 4 pairs。
  apps    = ["api"]
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


