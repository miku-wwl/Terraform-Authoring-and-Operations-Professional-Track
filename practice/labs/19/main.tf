terraform {
  required_version = ">= 1.5.0"
}

locals {
  import_workflow = [
    "先识别已经存在但尚未纳入 Terraform 管理的资源",
    "编写 import block，将真实资源 ID 映射到目标资源地址",
    "运行 terraform plan -generate-config-out=generated.tf 生成候选配置",
    "审查生成配置并执行 terraform apply 完成状态导入",
  ]

  legacy_resource = {
    id          = "manual-report-001"
    owner       = "platform"
    environment = "training"
  }
}

resource "terraform_data" "import_readiness" {
  input = local.legacy_resource
}

output "import_workflow" {
  value = local.import_workflow
}

output "managed_resource_id" {
  value = terraform_data.import_readiness.output.id
}
