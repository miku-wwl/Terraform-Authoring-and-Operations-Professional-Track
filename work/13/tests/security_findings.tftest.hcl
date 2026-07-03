run "security_findings_are_complete" {
  command = plan

  assert {
    condition     = contains(output.security_findings, "host_network 共享宿主机网络，绕过 NetworkPolicy")
    error_message = "必须说明 host_network 的安全风险。"
  }
}
