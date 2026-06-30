run "lab_81_test_contract" {
  command = plan

  assert {
    condition     = output.test_file == "tests/example.tftest.hcl"
    error_message = "Terraform test 文件位置 的测试契约必须成立。"
  }
}

