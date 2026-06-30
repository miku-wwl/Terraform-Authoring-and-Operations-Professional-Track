run "lab_82_test_contract" {
  command = plan

  assert {
    condition     = output.expected_port == 8080
    error_message = "Terraform test assertion 的测试契约必须成立。"
  }
}

