run "lab_83_test_contract" {
  command = plan

  assert {
    condition     = output.parallelism == 1
    error_message = "Terraform test 根级属性 的测试契约必须成立。"
  }
}

