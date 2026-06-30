terraform {
  required_version = ">= 1.5.0"
}


module "artifact" {
  source  = "./modules/artifact"
  name    = "lab-84"
  content = "Terraform modules 价值：由 root module 调用 child module 生成。"
}

output "artifact_path" {
  value = module.artifact.artifact_path
}

output "artifact_name" {
  value = module.artifact.artifact_name
}

output "module_topic" {
  value = "Terraform modules 价值"
}

