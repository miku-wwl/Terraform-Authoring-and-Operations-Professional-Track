run "scanning_notes_are_complete" {
  command = plan

  assert {
    condition     = contains(output.checkov_scanning_notes, "--skip-check 可按组织策略跳过低优先级规则")
    error_message = "必须说明 --skip-check 在企业 CI 中的用途。"
  }
}
