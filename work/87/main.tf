# 选择 Terraform Registry module 时，不要只看示例能不能复制运行。
# 真实项目里应先看 Registry/GitHub 上的维护信号：下载量、贡献者数量、
# open issues、文档是否完整、版本数量，以及源码是否需要额外审查。
# 本 lab 用 JSON 模拟这些信号，再用 for + if 把 module 分成 trusted、
# review 和 usable，练的是“选 module 前先评估质量和风险”。
terraform {
  required_version = ">= 1.5.0"
}

locals {
  registry_data = jsondecode(file("${path.module}/data/module_candidates.json"))

  modules = local.registry_data.modules

  ec2_module_names = [
    for module in local.modules : module.name
    if module.service == "ec2"
  ]

  trusted_modules_by_name = {
    for module in local.modules : module.name => module
    if module.downloads >= 100000 &&
    module.contributors >= 5 &&
    module.open_issues <= 10 &&
    module.has_documentation &&
    module.version_count >= 3 &&
    !module.source_review_required
  }

  review_required_module_names = [
    for module in local.modules : module.name
    if module.source_review_required ||
    module.contributors <= 1 ||
    !module.has_documentation ||
    module.version_count <= 1 ||
    module.downloads < 10000
  ]

  module_quality_labels = [
    for module in local.modules : "${module.name}:${contains(keys(local.trusted_modules_by_name), module.name) ? "trusted" : contains(local.review_required_module_names, module.name) ? "review" : "usable"}"
  ]

  recommended_ec2_module_name = try([
    for module in local.modules : module.name
    if module.service == "ec2" && contains(keys(local.trusted_modules_by_name), module.name)
  ][0], "")
}

resource "terraform_data" "lesson" {
  input = {
    topic              = "choosing the right terraform module"
    module_count       = length(local.modules)
    recommended_module = local.recommended_ec2_module_name
  }
}

output "modules" {
  description = "Module candidates decoded from data/module_candidates.json."
  value       = local.modules
}

output "ec2_module_names" {
  description = "Names of module candidates for EC2."
  value       = local.ec2_module_names
}

output "trusted_modules_by_name" {
  description = "Trusted module candidates keyed by module name."
  value       = local.trusted_modules_by_name
}

output "trusted_module_names" {
  description = "Trusted module names."
  value       = keys(local.trusted_modules_by_name)
}

output "review_required_module_names" {
  description = "Module names that should be avoided or manually source-reviewed."
  value       = local.review_required_module_names
}

output "module_quality_labels" {
  description = "Module quality labels derived from maintenance and trust signals."
  value       = local.module_quality_labels
}

output "recommended_ec2_module_name" {
  description = "Recommended trusted EC2 module name."
  value       = local.recommended_ec2_module_name
}
