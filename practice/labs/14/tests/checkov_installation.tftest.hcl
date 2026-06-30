run "installation_notes_are_ci_friendly" {
  command = plan

  assert {
    condition     = contains(output.checkov_installation_notes, "CI/CD 中应固定工具版本，而不是长期使用 latest")
    error_message = "必须提醒 CI/CD 中固定 Checkov 工具版本。"
  }
}

