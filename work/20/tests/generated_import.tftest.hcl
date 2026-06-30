run "generated_import_contract_is_clear" {
  command = apply

  assert {
    condition     = output.generated_config_command == "terraform plan -generate-config-out=generated.tf"
    error_message = "必须记录生成导入配置的命令。"
  }

  assert {
    condition     = output.import_block_example.to == "terraform_data.imported_security_group"
    error_message = "import block 必须明确目标资源地址。"
  }

  assert {
    condition     = length(output.managed_ports) == 3
    error_message = "模拟安全组必须保留三条入站端口规则。"
  }
}
