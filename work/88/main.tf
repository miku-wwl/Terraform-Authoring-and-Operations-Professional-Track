# Lab 88 知识点：组织内部 Terraform module 的基础目录结构。
#
# modules/ 表示平台或 SRE 团队维护的可复用 module，例如 ec2、
# security-group；teams/ 表示业务团队的调用入口示例，例如 team-a、
# team-b。这个 lab 用 JSON 模拟这种 monorepo 结构，并练习用
# jsondecode()、for 表达式和 concat() 整理目录、团队和 module 引用关系。
#
# 真实企业里不一定把所有 team 都放在同一个 Terraform 仓库；更常见的成熟
# 做法是平台团队维护 modules 仓，各 team 在自己的 Terraform 仓里通过
# git source + version tag 引用内部 module。本 lab 只是用单目录模型讲清楚
# modules 是可复用组件，teams 是消费方。
terraform {
  required_version = ">= 1.5.0"
}

locals {
  structure = jsondecode(file("${path.module}/data/module-structure.json"))

  root_folders = local.structure.root_folders

  modules = local.structure.modules

  teams = local.structure.teams

  references = local.structure.references

  module_paths = [for module in local.modules : module.path]

  team_paths = [for team in local.teams : team.path]

  module_names = [for module in local.modules : module.name]
  team_names   = [for team in local.teams : team.name]

  team_source_by_team = { for ref in local.references : ref.team => ref.source }

  base_structure_paths = concat(local.root_folders, local.module_paths, local.team_paths)

  planned_modules_by_team = { for team in local.teams : team.name => team.planned_modules }

  internal_module_policy = local.structure.organization_policy
}

resource "terraform_data" "lesson" {
  input = {
    topic                = "internal terraform module base structure"
    root_folders         = local.root_folders
    module_paths         = local.module_paths
    team_paths           = local.team_paths
    team_source_by_team  = local.team_source_by_team
    base_structure_paths = local.base_structure_paths
  }
}

output "root_folders" {
  description = "Top-level folders in the internal module repository."
  value       = local.root_folders
}

output "module_names" {
  description = "Reusable module names."
  value       = local.module_names
}

output "team_names" {
  description = "Team workspace names."
  value       = local.team_names
}

output "module_paths" {
  description = "Reusable module folder paths."
  value       = local.module_paths
}

output "team_paths" {
  description = "Team workspace folder paths."
  value       = local.team_paths
}

output "team_source_by_team" {
  description = "Planned relative module source path for each team."
  value       = local.team_source_by_team
}

output "planned_modules_by_team" {
  description = "Module names each team plans to reference."
  value       = local.planned_modules_by_team
}

output "internal_module_policy" {
  description = "Organization policy explaining why internal modules are preferred."
  value       = local.internal_module_policy
}

output "base_structure_paths" {
  description = "Complete base folder structure for the internal module repository."
  value       = local.base_structure_paths
}
