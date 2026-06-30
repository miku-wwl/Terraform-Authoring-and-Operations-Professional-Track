run "lab_80_test_contract" {
  command = plan

  assert {
    condition     = output.test_command == "terraform test"
    error_message = "Terraform test 框架概览 的测试契约必须成立。"
  }
}

