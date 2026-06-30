terraform {
  required_version = ">= 1.5.0"
}

moved {
  from = local_file.legacy_artifact
  to   = module.artifact.local_file.artifact
}

module "artifact" {
  source  = "./modules/artifact"
  name    = "lab-99"
  content = "moved block 迁移到模块：由 root module 调用 child module 生成。"
}

output "artifact_path" {
  value = module.artifact.artifact_path
}

output "artifact_name" {
  value = module.artifact.artifact_name
}

output "module_topic" {
  value = "moved block 迁移到模块"
}
