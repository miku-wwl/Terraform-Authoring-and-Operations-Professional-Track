# 本节知识点：
# - 理解 Terraform 可复用 module 的标准目录结构，而不是把所有代码随意堆在一起。
# - 区分 main.tf、variables.tf、outputs.tf、versions.tf、README.md 各自承担的职责。
# - 学会从架构职责边界设计 module，例如 compute、networking、database、storage，
#   避免把 VPC、EC2、S3、IAM、数据库等全部塞进一个巨大的 monolithic module。
# - 通过 Terraform 内置函数和表达式检查 module 结构，并从外部数据推导推荐的 module 拆分方案。
terraform {
  required_version = ">= 1.5.0"
}

locals {
  architecture = jsondecode(file("${path.module}/data/module_architecture.json"))

  services = local.architecture.requested_architecture.services

  standard_required_files = toset(["README.md", "main.tf", "variables.tf", "outputs.tf"])

  ec2_module_files = toset(fileset("${path.module}/modules/ec2", "*"))

  missing_required_files = setsubtract(local.standard_required_files, local.ec2_module_files)

  module_boundaries = sort(tolist(toset([for service in local.services : service.module_boundary])))

  module_catalog = {
    for boundary in local.module_boundaries : boundary => [
      for service in local.services : service.name
      if service.module_boundary == boundary
    ]
  }
}

module "ec2" {
  source = "./modules/ec2"

  service_name  = "ec2"
  instance_type = "t3.micro"
  tags = {
    Environment = "training"
    ManagedBy   = "terraform"
  }
}

resource "terraform_data" "lesson" {
  input = {
    topic                 = "standard module structure"
    standard_required     = local.standard_required_files
    detected_module_files = local.ec2_module_files
    module_boundaries     = local.module_boundaries
  }
}

output "standard_required_files" {
  description = "Minimal recommended files for a reusable Terraform module."
  value       = local.standard_required_files
}

output "ec2_module_files" {
  description = "Files detected in modules/ec2."
  value       = local.ec2_module_files
}

output "missing_required_files" {
  description = "Required standard module files missing from modules/ec2."
  value       = local.missing_required_files
}

output "architecture_service_count" {
  description = "Number of services in the requested architecture mock."
  value       = length(local.services)
}

output "module_boundaries" {
  description = "Unique module responsibility boundaries inferred from the architecture."
  value       = local.module_boundaries
}

output "module_catalog" {
  description = "Recommended module boundary to service-name catalog."
  value       = local.module_catalog
}

output "ec2_module_metadata" {
  description = "Metadata returned from the local EC2 module."
  value       = module.ec2.metadata
}
