terraform {
  required_version = ">= 1.5.0"
}


module "artifact" {
  source  = "./modules/artifact"
  name    = "lab-98"
  content = "标准模块结构：由 root module 调用 child module 生成。"
}

output "artifact_path" {
  value = module.artifact.artifact_path
}

output "artifact_name" {
  value = module.artifact.artifact_name
}

output "module_topic" {
  value = "标准模块结构"
}

