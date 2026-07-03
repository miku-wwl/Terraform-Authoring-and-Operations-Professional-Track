terraform {
  required_version = ">= 1.5.0"
}

locals {
  # TODO 1：补充 import block 生成候选配置的命令说明。
  # 提示：terraform plan -generate-config-out=generated.tf 可自动生成候选 HCL。
  # TODO 2：补全遗留资源的业务 ID。
  # 提示：格式为 manual-report-001。
  import_workflow = [
    "先识别已经存在但尚未纳入 Terraform 管理的资源",
    "编写 import block，将真实资源 ID 映射到目标资源地址",
    "TODO：补充 import block 生成候选配置的命令",
    "审查生成配置并执行 terraform apply 完成状态导入",
  ]

  legacy_resource = {
    id          = "TODO-manual-resource-id"
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
