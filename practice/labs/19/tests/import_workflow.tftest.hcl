run "import_workflow_is_documented" {
  command = apply

  assert {
    condition     = contains(output.import_workflow, "运行 terraform plan -generate-config-out=generated.tf 生成候选配置")
    error_message = "必须说明 import block 与 generate-config-out 的关系。"
  }

  assert {
    condition     = output.managed_resource_id == "manual-report-001"
    error_message = "必须保留被接管资源的业务 ID。"
  }
}
